require 'spec_helper'

describe DigestService do

  describe "generate_digest_set" do

    before(:each) do

      #Contrubitor that talks a lot
      @contributor = Factory.create(:registered_user, :name => 'Big Talker', :avatar => nil)

      #Conversations
      @convo_fresh_with_subs = Factory.create(:conversation, :title => 'Fresh with Subscriptions')
      @convo_fresh_without_subs = Factory.create(:conversation, :title => 'Fresh without Subscriptions')
      @convo_stale_with_subs = Factory.create(:conversation, :title => 'Stale with Subscriptions')
      @convo_stale_without_subs = Factory.create(:conversation, :title => 'Stale without Subscriptions')


      #create instance of DigestService
      @service = DigestService.new

    end

    context "When users have opted out of the digest" do

      before(:each) do
        @person_unsubscribed_from_digest = Factory.create(:registered_user, :name => 'No Subscriptions', :avatar => nil)
      end

      it "Generates an empty set" do
        set = @service.generate_digest_set
        set.should be_empty
      end

    end

    context "When users have subscribed to conversations" do

      before(:each) do
        @person_with_subs = Factory.create(:registered_user, :name => 'I Subscribe', :daily_digest => true, :avatar => nil)

        #Subscriptions
        @sub_fresh = Factory.create(:conversation_subscription, :person => @person_with_subs, :subscribable => @convo_fresh_with_subs)
        @sub_stale = Factory.create(:conversation_subscription, :person => @person_with_subs, :subscribable => @convo_stale_with_subs)

        #Contributions
        Factory.create(:contribution, :person => @contributor, :conversation => @convo_stale_with_subs, :created_at => 2.days.ago)
        Factory.create(:contribution, :person => @contributor, :conversation => @convo_stale_without_subs, :created_at => 2.days.ago)
      end

      context "No new contributions added yesterday" do

        it "should generate an empty set when no contributions were added during the time range" do
          set = @service.generate_digest_set
          set.should be_instance_of Hash
          set.should be_empty
        end

      end

      context "Contributions were added Yesterday" do

        before(:each) do
          #Issue
          @fresh_issue = Factory.create(:issue)

          #Subscriptions
          @sub_fresh_issue = Factory.create(:issue_subscription, :person => @person_with_subs, :subscribable => @fresh_issue)

          #Contributions
          Factory.create(:issue_contribution, :person => @contributor, :created_at => 1.day.ago)
          Factory.create(:contribution, :person => @contributor, :conversation => @convo_fresh_with_subs, :created_at => 1.day.ago)
          Factory.create(:contribution, :person => @contributor, :conversation => @convo_fresh_without_subs, :created_at => 1.day.ago)
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
      @person_with_subs = Factory.create(:registered_user, :name => 'I Subscribe', :daily_digest => true, :avatar => nil)
      @contributor = Factory.create(:registered_user, :name => 'Big Talker', :avatar => nil)
      @convo_fresh_with_subs = Factory.create(:conversation, :title => 'Fresh with Subscriptions')
      @sub_fresh = Factory.create(:conversation_subscription, :person => @person_with_subs, :subscribable => @convo_fresh_with_subs)
      @first_contribution = Factory.create(:contribution, :person => @contributor, :conversation => @convo_fresh_with_subs, :created_at => 1.day.ago)

      digest = DigestService.new
      digest.generate_digest_set
      digest.group_contributions_by_conversation
      digest.digest_set[@person_with_subs][0][1].should be_an_instance_of Array
      digest.digest_set[@person_with_subs][0][1][0].should == @first_contribution
    end

  end


  describe "process_daily_digest" do

    before(:each) do

      @person_with_subs = Factory.create(:registered_user, :name => 'I Subscribe', :daily_digest => true, :avatar => nil)
      @contributor = Factory.create(:registered_user, :name => 'Big Talker', :avatar => nil)
      @convo_fresh_with_subs = Factory.create(:conversation, :title => 'Fresh with Subscriptions')
      convo_array = [ [@convo_fresh_with_subs, [ Factory.create(:contribution, :person => @contributor, :conversation => @convo_fresh_with_subs, :created_at => 1.day.ago) ] ] ]
      @digest_set = {
        @person_with_subs => convo_array
      }

      ActionMailer::Base.deliveries.clear
    end

    it "should send one email for each person in the set" do
      #TODO: figure out why this doesn't work
      # Without mocking we are reaching through to the view, we want to isloate from the view
      #notifier = mock(Notifier).should_receive(:deliver).and_return(true)
      #Notifier.should_receive(:daily_digest).with(@person_with_subs, @convo_array).once.and_return(notifier)
      service = DigestService.new
      service.process_daily_digest(@digest_set)
      ActionMailer::Base.deliveries.length.should == @digest_set.size
    end

    it "should not send any emails when the data set is empty"


  end

end
