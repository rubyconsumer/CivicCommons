class UserController < ApplicationController

  def edit
  end

  def show
    @user = Person.includes(:contributions, :subscriptions).find(params[:id])

    @contributions = @user.contributions.collect do |contribution|
      ContributionPresenter.new(contribution)
    end
    @contributions = @contributions.paginate(page: params[:page], per_page: 6)

    @issue_subscriptions = @user.subscriptions.select do |subscription|
      subscription.subscribable_type == "Issue"
    end

    @conversation_subscriptions = @user.subscriptions - @issue_subscriptions
  end

  def update
    @person = Person.find(params[:id])
    respond_to do |format|
      if @person.update_attributes(params[:person])
        flash[:notice] = "Successfully edited your profile"
        format.html { redirect_to user_path(@person) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

end
