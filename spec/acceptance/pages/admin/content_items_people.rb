module CivicCommonsDriver
module Pages
class Admin
class ContentItemsPeople
  SHORT_NAME = :admin_content_items_people
  include Page
  
  has_link(:add_host,'Add Host', :admin_add_content_item_host)
  has_link(:add_guest,'Add Guest', :admin_add_content_item_guest)
  has_link(:remove_host,'Remove this host', :admin_content_items_people)
  has_link(:remove_guest,'Remove this guest', :admin_content_items_people)

  class AddHost
    SHORT_NAME = :admin_add_content_item_host
    include Page
    include Database
    has_link(:all,'All', :admin_add_content_item_host)
    has_link(:a,'A', :admin_add_content_item_host)
    has_button(:add_host, 'Add this person as host', :admin_content_items_people)
    has_select(:host, 'person_id')
  end

  class AddGuest
    SHORT_NAME = :admin_add_content_item_guest
    include Page
    include Database
    has_link(:all,'All', :admin_add_content_item_guest)
    has_link(:a,'A', :admin_add_content_item_guest)
    has_button(:add_guest, 'Add this person as guest', :admin_content_items_people)
    has_select(:guest, 'person_id')
  end

end
end
end
end
