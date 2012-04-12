require 'spec_helper'

describe DigestService do

  describe "generate_digest_set" do

    before(:each) do

      #Contrubitor that talks a lot
      @contributor = FactoryGirl.create(:registered_user, :name => 'Big Talker', :avatar => nil)

      #Conversations
      @convo_fresh_with_subs = FactoryGirl.create(:conversation, :title => 'Fresh with Subscriptions')
      @convo_fresh_without_subs = FactoryGirl.create(:conversation, :title => 'Fresh without Subscriptions')
      @convo_stale_with_subs = FactoryGirl.create(:conversation, :title => 'Stale with Subscriptions')
      @convo_stale_without_subs = FactoryGirl.create(:conversation, :title => 'Stale without Subscriptions')

      #create instance of DigestService
      @service = DigestService.new

    end

    context "When users have opted out of the digest" do

      before(:each) do
        @person_unsubscribed_from_digest = FactoryGirl.create(:registered_user, :daily_digest => false,  :name => 'No Subscriptions', :avatar => nil)
      end

      it "Generates an empty set" do
        set = @service.generate_digest_set
        set.should be_empty
      end

    end

    context "When users have subscribed to conversations" do

      before(:each) do
        @person_with_subs = FactoryGirl.create(:registered_user, :name => 'I Subscribe', :daily_digest => true, :avatar => nil)

        #Subscriptions
        @sub_fresh = FactoryGirl.create(:conversation_subscription, :person => @person_with_subs, :subscribable => @convo_fresh_with_subs)
        @sub_stale = FactoryGirl.create(:conversation_subscription, :person => @person_with_subs, :subscribable => @convo_stale_with_subs)

        #Contributions
        FactoryGirl.create(:contribution, :person => @contributor, :conversation => @convo_stale_with_subs, :created_at => 2.days.ago)
        FactoryGirl.create(:contribution, :person => @contributor, :conversation => @convo_stale_without_subs, :created_at => 2.days.ago)
      end

      context "No new contributions added yesterday" do

        it "should generate a digest set with a person but no contribution data" do
          set = @service.generate_digest_set
          set.should be_instance_of Hash
          @service.digest_set[@person_with_subs].should == []
        end

      end

      context "Contributions were added Yesterday" do

        before(:each) do
          #Issue
          @fresh_issue = FactoryGirl.create(:issue)

          #Subscriptions
          @sub_fresh_issue = FactoryGirl.create(:issue_subscription, :person => @person_with_subs, :subscribable => @fresh_issue)

          #Contributions
          FactoryGirl.create(:issue_contribution, :person => @contributor, :created_at => 1.day.ago)
          FactoryGirl.create(:contribution, :person => @contributor, :conversation => @convo_fresh_with_subs, :created_at => 1.day.ago)
          FactoryGirl.create(:contribution, :person => @contributor, :conversation => @convo_fresh_without_subs, :created_at => 1.day.ago)
        end

        it "should generate a valid data set when there are fresh contributions and at least one valid subscriber" do

          set = @service.generate_digest_set

          set.should be_instance_of Hash
          set.should have(1).items
          set.should have_key(@person_with_subs)

          convos = set[@person_with_subs]
          convos.should be_instance_of Array
          convos.should have(1).items
          convos[0].first.should == @convo_fresh_with_subs
        end

        it "should not include contributions that were made on issues" do
          set = @service.generate_digest_set

          set.should be_an_instance_of Hash
          set.should have(1).items
          set[@person_with_subs].should_not include(@sub_fresh_issue)
        end

      end

    end

  end

  describe "DigestService#group_contributions_by_conversation" do

    it "Creates an array of contributions for the given conversation" do
      @person_with_subs = FactoryGirl.create(:registered_user, :name => 'I Subscribe', :daily_digest => true, :avatar => nil)
      @contributor = FactoryGirl.create(:registered_user, :name => 'Big Talker', :avatar => nil)
      @convo_fresh_with_subs = FactoryGirl.create(:conversation, :title => 'Fresh with Subscriptions')
      FactoryGirl.create(:conversation_subscription, person: @person_with_subs, subscribable: @convo_fresh_with_subs)
      @first_contribution = FactoryGirl.create(:contribution, :person => @contributor, :conversation => @convo_fresh_with_subs, :created_at => 1.day.ago)
      @second_contribution = FactoryGirl.create(:contribution, :person => @contributor, :conversation => @convo_fresh_with_subs, :created_at => 1.day.ago)

      digest = DigestService.new
      digest.generate_digest_set
      digest.digest_set[@person_with_subs][0][1].should be_an_instance_of Array
      digest.digest_set[@person_with_subs][0][1][0].should == @first_contribution
      digest.digest_set[@person_with_subs][0][1][1].should == @second_contribution
    end

  end


  describe "process_daily_digest" do

    before(:each) do

      @person_with_subs = FactoryGirl.create(:registered_user, :name => 'I Subscribe', :daily_digest => true, :avatar => nil)
      @contributor = FactoryGirl.create(:registered_user, :name => 'Big Talker', :avatar => nil)
      @convo_fresh_with_subs = FactoryGirl.create(:conversation, :title => 'Fresh with Subscriptions')
      convo_array = [ [@convo_fresh_with_subs, [ FactoryGirl.create(:contribution, :person => @contributor, :conversation => @convo_fresh_with_subs, :created_at => 1.day.ago) ] ] ]
      @digest_set = {
        @person_with_subs => convo_array
      }

      ActionMailer::Base.deliveries.clear
    end


    it "should send one email for each person in the set" do
      service = DigestService.new
      service.process_daily_digest(@digest_set)
      ActionMailer::Base.deliveries.length.should == @digest_set.size
    end

    it "should not send any emails when the data set is empty" do
      service = DigestService.new
      @digest_set = {}
      service.process_daily_digest(@digest_set)
      ActionMailer::Base.deliveries.length.should == 0
    end

    it "should not send any emails when the subscribers conversation array is empty" do
      service = DigestService.new
      @digest_set[@person_with_subs] = []
      service.process_daily_digest(@digest_set)
      ActionMailer::Base.deliveries.length.should == 0
    end

  end

end
