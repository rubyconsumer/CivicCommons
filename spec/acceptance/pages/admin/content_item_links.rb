module CivicCommonsDriver
module Pages
class Admin
class ContentItemLink
  SHORT_NAME = :admin_content_item_links
  include Page
  
  has_link(:add_link,'Add Link', :admin_add_content_item_link)
  has_link_for(:edit, 'Edit', :admin_edit_content_item_link)
  has_link_for(:remove, 'Remove', :admin_content_item_links)

  class New
    SHORT_NAME = :admin_add_content_item_link
    include Page
    include Database
    has_field(:title, 'content_item_link_title')
    has_field(:url, 'content_item_link_url')
    has_field(:description, 'content_item_link_description')
    has_button(:create_link, 'Create Content item link', :admin_content_item_links)
  end

  class Edit
    SHORT_NAME = :admin_edit_content_item_link
    include Page
    include Database
    has_field(:title, 'content_item_link_title')
    has_field(:url, 'content_item_link_url')
    has_field(:description, 'content_item_link_description')
    has_button(:update_link, 'Update Content item link', :admin_content_item_links)
  end

end
end
end
end
