class UserController < ApplicationController
  include OrganizationsHelper
  before_filter :require_user, :only => [:join_as_member, :remove_membership]
  before_filter :require_ssl, :only => [:update]
  before_filter :verify_ownership?, :only => [:edit, :update, :destroy_avatar]

  def verify_ownership?
    unless(current_person && current_person == Person.find(params[:id]))
      redirect_to community_path
    end
  end
  
  def join_as_member
    @organization = Organization.find(params[:id])
    if @organization && @organization.join_as_member(current_person) 
      respond_to do |format|
        format.js { render :template => '/organizations/join_as_member.js'  } 
      end
    else
      respond_to do |format|
        format.js { render :nothing => true, :status => 500 }
      end
    end
  end
  
  def remove_membership
    @organization = Organization.find(params[:id])
    if @organization && @organization.remove_member(current_person)
      respond_to do |format|
        format.js { render :template => '/organizations/remove_membership.js' }
      end
    else
      respond_to do |format|
        format.js { render :nothing => true, :status => 500 }
      end
      
    end
  end
  
  def confirm_membership
    render :template => '/organizations/confirm_membership_modal', :layout => false
  end

  def mockup
    show
  end
  
  def edit
    @person = Person.find(params[:id])
    @person.require_zip_code = true  #did this So that there is a validation error on the view.
    @person.valid?
  end

  def show
    @user = Person.includes(:contributions, :subscriptions).find(params[:id])
    @recent_items = Activity.most_recent_activity_items_for_person(@user).paginate(page: params[:page], per_page: 10)

    @issue_subscriptions = @user.subscriptions.where(:subscribable_type => 'Issue').reverse
    @conversation_subscriptions = @user.subscriptions.where(:subscribable_type => 'Conversation').reverse

    respond_to do |format|
      format.html
      format.xml
    end
  end

  def update
    @person = Person.find(params[:id])
    @person.require_zip_code = true
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
