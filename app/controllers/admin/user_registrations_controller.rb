class Admin::UserRegistrationsController < Admin::DashboardController

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(params[:person])
    if @person.confirm!
      flash[:notice] = 'Thank you for registering with the Civic Commons'
      redirect_to admin_people_path
    else
      render :new
    end
  end

end
