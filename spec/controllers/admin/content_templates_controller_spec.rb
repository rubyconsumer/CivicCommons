require 'spec_helper'

module Admin
  describe ContentTemplatesController do

    before(:all) do
      @content_templates = {}
      (1..5).each do 
        template = Factory.create(:content_template)
        @content_templates[template.id] = template
      end
    end

    after(:all) do
      ContentTemplate.delete_all
      Person.delete_all
    end

    describe "GET index" do

      it "assigns all content_templates as @content_templates" do
        pending
        get :index
        assigns[:content_templates].size.should == @content_templates.size
      end

    end

    describe "GET show" do

      it "assigns the requested content_template as @content_template" do
        pending
        template = @content_templates[@content_templates.keys.first]
        get :show, :id => template.id.to_s
        assigns[:content_template].should eq template
      end

    end

    describe "GET new" do

      it "assigns a new content_template as @content_template" do
        pending
        get :new
        assigns[:content_template].should_not be_nil
      end

    end

    describe "GET edit" do

      it "assigns the requested content_template as @content_template" do
        pending
        template = @content_templates[@content_templates.keys.first]
        get :edit, :id => template.id.to_s
        assigns[:content_template].should eq template
      end

    end

    describe "POST create" do

      describe "with valid params" do

        before(:each) do
          params = Factory.attributes_for(:content_template)
          post :create, :params => params
        end

        it "assigns a newly created content_template as @content_template" do
          pending
          assigns[:content_template].name.should eq template.name
          assigns[:content_template].cached_slug.should eq template.cached_slug
          assigns[:content_template].template.should eq template.template
        end

        it "redirects to the created content_template" do
          pending
          response.should redirect_to admin_content_template_path(assigns[:content_template])
        end

      end

      describe "with invalid params" do

        before(:each) do
          params = Factory.attributes_for(:content_template)
          params.delete(:name)
          post :create, :params => params
        end

        it "assigns a newly created but unsaved content_template as @content_template" do
          pending
          assigns[:content_template].name.should eq params[:name]
          assigns[:content_template].cached_slug.should eq params[:cached_slug]
          assigns[:content_template].template.should eq params[:template]
        end

        it "re-renders the 'new' template" do
          pending
          response.should render_template("new")
        end

      end

    end

    describe "PUT update" do

      describe "with valid params" do

        before(:all) do
          @params = @content_templates[@content_templates.keys.first].attributes
          @params[:name] = "Some completely different but valid name"
          put :update, :id => @params['id'], :params => @params
        end

        it "updates the requested content_template" do
          pending
          ContentTemplate.find_by_id(@params['id']).name.should eq @params['name']
        end

        it "assigns the requested content_template as @content_template" do
          pending
        end

        it "redirects to the content_template" do
          pending
        end

      end

      describe "with invalid params" do

        it "assigns the content_template as @content_template" do
          pending
        end

        it "re-renders the 'edit' template" do
          pending
        end

      end

    end

    describe "DELETE destroy" do

      it "destroys the requested content_template" do
        pending
      end

      it "redirects to the content_templates list" do
        pending
      end

    end

  end
end
