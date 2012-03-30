require 'spec_helper'

describe ReflectionCommentsController do

  def mock_conversation(stubs={})
    @mock_conversation ||= mock_model(Conversation, stubs).as_null_object
  end

  def mock_reflection(stubs={})
    @mock_reflection ||= mock_model(Reflection, stubs).as_null_object
  end

  def mock_reflection_comment(stubs={})
    @mock_reflection_comment ||= mock_model(ReflectionComment, stubs).as_null_object
  end
  

  def stub_person(stubs={:id => 111})
    @stub_person ||= stub_model(Person, stubs).as_null_object
  end

  before(:each) do
    @controller.stub!(:require_user).and_return(true)
    @controller.stub!(:current_person).and_return(stub_person)
    Conversation.stub(:find).with(7) { mock_conversation }
    mock_conversation.stub_chain(:reflections,:find).and_return(mock_reflection)
  end

  describe "POST create" do
    describe "with valid params" do
      it "redirects to the reflection_path" do
        @mock_reflection.stub_chain(:comments, :build).with({'these' => 'params'}) { mock_reflection(:save => true) }
        post :create, :reflection_comment => {'these' => 'params'}, :conversation_id => 7, :reflection_id => 123
        response.should redirect_to(conversation_reflection_path(mock_conversation, mock_reflection))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved reflection as @reflection" do
        @mock_reflection.stub_chain(:comments, :build).with({'these' => 'params'}) { mock_reflection(:save => false) }
        post :create, :reflection_comment => {'these' => 'params'}, :conversation_id => 7, :reflection_id => 123
        assigns(:reflection).should be(mock_reflection)
      end

      it "re-renders the 'new' template" do
        @mock_reflection.stub_chain(:comments, :build).with({}) { mock_reflection(:save => false) }
        post :create, :reflection_comment => {}, :conversation_id => 7, :reflection_id => 123
        response.should render_template(:controller => [@conversation, @reflection], :action => "new") #render_template("new")
      end
    end
  end


end
