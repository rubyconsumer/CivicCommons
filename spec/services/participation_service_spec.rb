require 'spec_helper'

describe ParticipationService do
  describe 'participants_by_issue' do
    let(:convo1) {Factory.create(:conversation, :issues => [issue])}
    let(:convo2) {Factory.create(:user_generated_conversation, :issues => [issue])}
    let(:contrib){Factory.create(:contribution, :conversation => convo2)}
    let(:issue)  {Factory.create(:issue)}

    it "ignores issues with conversations without participants" do
      convo1.issues = [issue]
      convo2.issues = [issue]
      contrib.conversation = convo2

      issue.conversations.should == [convo1, convo2]

      ps = ParticipationService.new
      ps.participants_by_issue(issue.id).should == 1
    end
  end
end
