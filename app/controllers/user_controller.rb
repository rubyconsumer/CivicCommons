class UserController < ApplicationController

  def edit
  end

  def show
    @user = Person.find(params[:id])
    @contributions = @user.contributions.collect do |contribution|
      ContributionPresenter.new(contribution)
    end
    @contributions = @contributions.paginate(page: params[:page], per_page: 6)
  end

  def update
  end

end
