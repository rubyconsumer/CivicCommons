class BlogAdminColOnPeopleTab < ActiveRecord::Migration
  def up
    add_column :people, :blog_admin, :boolean
  end

  def down
    remove_column :people, :blog_admin
  end
end