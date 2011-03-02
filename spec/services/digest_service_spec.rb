require 'spec_helper'

module Services

  describe DigestService do

    before(:each) do

      # two people: one with a sub and one without
      # four convos: two with updates today and two without
      # the person with subs is subscribed to one convo with updates and one without

      @contributer = Factory.create(:registered_user, :name => 'Big Talker', :avatar => nil)

      @person_with_subs = Factory.create(:registered_user, :name => 'I Subscribe', :daily_digest => true, :avatar => nil)
      @person_without_subs = Factory.create(:registered_user, :name => 'No Subscriptions', :daily_digest => true, :avatar => nil)

      @convo_fresh_with_subs = Factory.create(:conversation, :title => 'Fresh with Subscriptions')
      @convo_fresh_without_subs = Factory.create(:conversation, :title => 'Fresh without Subscriptions')
      @convo_stale_with_subs = Factory.create(:conversation, :title => 'Stale with Subscriptions')
      @convo_stale_without_subs = Factory.create(:conversation, :title => 'Stale without Subscriptions')

      @sub_fresh = Factory.create(:conversation_subscription, :person => @person_with_subs, :subscribable => @convo_fresh_with_subs)
      @sub_stale = Factory.create(:conversation_subscription, :person => @person_with_subs, :subscribable => @convo_stale_with_subs)

      Factory.create(:contribution, :person => @contributer, :conversation => @convo_fresh_with_subs, :created_at => 1.day.ago)
      Factory.create(:contribution, :person => @contributer, :conversation => @convo_fresh_without_subs, :created_at => 1.day.ago)
      Factory.create(:contribution, :person => @contributer, :conversation => @convo_stale_with_subs, :created_at => 2.days.ago)
      Factory.create(:contribution, :person => @contributer, :conversation => @convo_stale_without_subs, :created_at => 2.days.ago)

      @service = DigestService.new

    end

    describe "generate_digest_set" do

      # this should pass
      it "should generate an empty set when no contributions were added during the time range"

      # this should pass
      it "should generate an empty set when no users are subscribed to digests"

      # this will fail
      it "should not include conversations for a given subscriber when the only contribution is from them"

      # this should pass
      it "should generate a valid data set when there are fresh contributions and at least one valid subscriber" do

        set = @service.generate_digest_set

        set.should be_instance_of Hash
        set.should have(1).items
        set.should have_key(@person_with_subs)

        convos = set[@person_with_subs]
        convos.should be_instance_of Array
        convos.should have(1).items
        convos[0].should == @convo_fresh_with_subs

      end

    end

    describe "process_daily_digest" do

      before(:each) do

        @convo_array = [ @convo_fresh_with_subs ]
        @digest_set = {
          @person_with_subs => @convo_array
        }

        ActionMailer::Base.deliveries.clear
      end

      it "should send one email for each person in the set" do

        #TODO: figure out why this doesn't work
        # Without mocking we are reaching through to the view, we want to isloate from the view
        #notifier = mock(Notifier).should_receive(:deliver).and_return(true)
        #Notifier.should_receive(:daily_digest).with(@person_with_subs, @convo_array).once.and_return(notifier)

        @service.process_daily_digest(@digest_set)
        ActionMailer::Base.deliveries.length.should == @digest_set.size

      end

      it "should not send any emails when the data set is empty"


    end

  end

end
