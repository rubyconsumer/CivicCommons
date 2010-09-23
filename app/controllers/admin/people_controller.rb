class Admin::PeopleController < Admin::Dashboard
  
  #GET admin/people/
  def index
    @people = Person.all
  end

  #GET admin/people/new
  def new
    @person = Person.new(params[:person])
  end

  #POST admin/people
  def create
    @person = Person.new(params[:person])
    @person.create_proxy
    if @person.save
      flash[:notice] = "Thank you for creating the proxy account"
      redirect_to admin_people_path
    else
      render new_admin_person_path
    end  
  end  
  
  #GET admin/people/1/edit
  def edit
  end
  
  #PUT admin/people/1
  def create
    @person = Person.find(params[:id])
    if @person.update_attributes(params[:person])
      flash[:notice] = "Successfully updated person record"
      redirect_to admin_people_path
    else
      render edit_admin_person_path(@person)
    end
  end

  #GET admin/people/1
  def show
    @person = Person.find(params[:id])
  end
  
  #DELETE admin/people/1
  def destroy
    @person = Person.find(params[:id])
    @person.destroy
  end

end
