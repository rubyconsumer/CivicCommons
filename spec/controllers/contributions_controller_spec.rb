require 'spec_helper'

describe ContributionsController do

  def mock_contribution(stubs={})
    @mock_contribution ||= mock_model(Contribution, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all contributions as @contributions" do
      Contribution.stub(:all) { [mock_contribution] }
      get :index
      assigns(:contributions).should eq([mock_contribution])
    end
  end

  describe "GET show" do
    before(:each) do
      @person = Factory.create(:normal_person)
      @controller.stub(:current_person).and_return(@person)
    end
    it "assigns the requested contribution as @contribution" do
      Contribution.stub(:find).with("37") { mock_contribution }
      get :show, :id => "37"
      assigns(:contribution).should be(mock_contribution)
    end
    it "records a visit to the issue passing the current user" do
      Contribution.stub(:find).with("37") { mock_contribution }
      mock_contribution.should_receive(:visit!).with(@person.id)
      get :show, :id => "37"
    end

  end

  describe "GET new" do
    it "assigns a new contribution as @contribution" do
      Contribution.stub(:new) { mock_contribution }
      get :new
      assigns(:contribution).should be(mock_contribution)
    end
  end

  describe "GET edit" do
    it "assigns the requested contribution as @contribution" do
      Contribution.stub(:find).with("37") { mock_contribution }
      get :edit, :id => "37"
      assigns(:contribution).should be(mock_contribution)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created contribution as @contribution" do
        Contribution.stub(:new).with({'these' => 'params'}) { mock_contribution(:save => true) }
        post :create, :contribution => {'these' => 'params'}
        assigns(:contribution).should be(mock_contribution)
      end

      it "redirects to the created contribution" do
        Contribution.stub(:new) { mock_contribution(:save => true) }
        post :create, :contribution => {}
        response.should redirect_to(contribution_url(mock_contribution))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved contribution as @contribution" do
        Contribution.stub(:new).with({'these' => 'params'}) { mock_contribution(:save => false) }
        post :create, :contribution => {'these' => 'params'}
        assigns(:contribution).should be(mock_contribution)
      end

      it "re-renders the 'new' template" do
        Contribution.stub(:new) { mock_contribution(:save => false) }
        post :create, :contribution => {}
        response.should render_template("new")
      end
    end

  end

  #describe "PUT update" do
  #
  #  describe "with valid params" do
  #    it "updates the requested contribution" do
  #      Contribution.should_receive(:find).with("37") { mock_contribution }
  #      mock_contribution.should_receive(:update_attributes).with({'these' => 'params'})
  #      put :update, :id => "37", :contribution => {'these' => 'params'}
  #    end
  #
  #    it "assigns the requested contribution as @contribution" do
  #      Contribution.stub(:find) { mock_contribution(:update_attributes => true) }
  #      put :update, :id => "1"
  #      assigns(:contribution).should be(mock_contribution)
  #    end
  #
  #    it "redirects to the contribution" do
  #      Contribution.stub(:find) { mock_contribution(:update_attributes => true) }
  #      put :update, :id => "1"
  #      response.should redirect_to(contribution_url(mock_contribution))
  #    end
  #  end
  #
  #  describe "with invalid params" do
  #    it "assigns the contribution as @contribution" do
  #      Contribution.stub(:find) { mock_contribution(:update_attributes => false) }
  #      put :update, :id => "1"
  #      assigns(:contribution).should be(mock_contribution)
  #    end
  #
  #    it "re-renders the 'edit' template" do
  #      Contribution.stub(:find) { mock_contribution(:update_attributes => false) }
  #      put :update, :id => "1"
  #      response.should render_template("edit")
  #    end
  #  end
  #
  #end
  #
  #describe "DELETE destroy" do
  #  it "destroys the requested contribution" do
  #    Contribution.should_receive(:find).with("37") { mock_contribution }
  #    mock_contribution.should_receive(:destroy)
  #    delete :destroy, :id => "37"
  #  end
  #
  #  it "redirects to the contributions list" do
  #    Contribution.stub(:find) { mock_contribution }
  #    delete :destroy, :id => "1"
  #    response.should redirect_to(contributions_url)
  #  end
  #end

end
