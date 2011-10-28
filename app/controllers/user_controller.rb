class UserController < ApplicationController

  before_filter :require_ssl, :only => [:update]
  before_filter :verify_ownership?, :only => [:edit, :update, :destroy_avatar]

  def verify_ownership?
    unless(current_person && current_person == Person.find(params[:id]))
      redirect_to community_path
    end
  end

  def edit
    @person = Person.find(params[:id])
    @person.valid?(:update) #did this So that there is a validation error on the view.
  end

  def show
    @user = Person.includes(:contributions, :subscriptions).find(params[:id])
    @recent_items = Activity.recent_items_for_person(@user).collect{|a| a.item}.paginate(page: params[:page], per_page: 10)

    @issue_subscriptions = @user.subscriptions.where(:subscribable_type => 'Issue')
    @conversation_subscriptions = @user.subscriptions.where(:subscribable_type => 'Conversation')

    respond_to do |format|
      format.html
      format.xml do
        @recent_items = Activity.recent_items_for_person(@user).paginate(page: params[:page], per_page: 10)
        @user
      end
    end
  end

  def update
    @person = Person.find(params[:id])
    respond_to do |format|
      if @person.update_attributes(params[:person])
        flash[:notice] = "Successfully edited your profile"
        format.html { redirect_to user_url(@person) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

 def destroy_avatar
  @person = Person.find(params[:id])
  @person.avatar = nil
  if @person.save
    respond_to do |format|
      format.js { render :json => { :avatarUrl => ( @person.facebook_authenticated? && !@person.avatar? ? @person.facebook_profile_pic_url : @person.avatar.url )} }
    end
  else
    respond_to do |format|
      format.js { render :nothing => true, :status => 500 }
    end
  end
 end
end
