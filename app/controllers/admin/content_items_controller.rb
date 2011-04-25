class Admin::ContentItemsController < Admin::DashboardController

  #GET admin/content_items
  def index
    @content_items = ContentItem.all
  end

  def new
    @content_item = ContentItem.new(params[:content_item])
    @authors = Person.find_all_by_admin(true)
    @content_item.author = current_person
  end

  def create
    params[:content_item][:person_id] = current_person[:id]
    @content_item = ContentItem.new(params[:content_item])
    if @content_item.save
      respond_to do |format|
        format.html { redirect_to(admin_content_item_path(@content_item), :notice => "Your content item has been created!") }
      end
    else
      respond_to do |format|
        format.html { render :new }
      end
    end
  end

  def show
    @content_item = ContentItem.find(params[:id])
    @person = Person.find(@content_item.person_id)
  end

  def edit
    @content_item = ContentItem.find(params[:id])
    @authors = Person.find_all_by_admin(true)
  end

  def destroy
    @content_item = ContentItem.find(params[:id])
    @content_item.destroy
    flash[:notice] = "Successfully deleted content item"
    redirect_to admin_content_items_path
  end

  def update
    @content_item = ContentItem.find(params[:id])
    respond_to do |format|
      if @content_item.update_attributes(params[:content_item])
        flash[:notice] = "Successfully edited your Content Item"
        format.html { redirect_to admin_content_items_path }
      else
        format.html { render :action => "edit" }
      end
    end
  end
end
