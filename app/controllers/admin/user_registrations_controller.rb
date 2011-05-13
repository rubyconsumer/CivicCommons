class Admin::UserRegistrationsController < Admin::DashboardController

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(params[:person])
    if @person.confirm!
      redirect_to admin_people_path
    else
      render :new
    end
  end

end
