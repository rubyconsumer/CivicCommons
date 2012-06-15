module CivicCommonsDriver
module Pages
class Admin
class FeaturedOpportunities
  SHORT_NAME = :admin_featured_opportunities
  include Page
  
  has_link(:add_featured_opportunity,'Add Featured Opportunity', :admin_add_featured_opportunity)
  has_link_for(:edit, 'Edit', :admin_edit_featured_opportunity)
  has_link_for(:delete, 'Delete', :admin_featured_opportunities)

  class New
    SHORT_NAME = :admin_add_featured_opportunity
    include Page
    include Database
    
    has_select(:conversation, 'featured_opportunity_conversation_id')
    has_select(:contribution, 'featured_opportunity_contribution_ids')
    has_select(:action, 'featured_opportunity_action_ids')
    has_select(:reflection, 'featured_opportunity_reflection_ids')
    has_button(:create, 'Create Featured opportunity', :admin_featured_opportunity)
  end
  
  class Show
    SHORT_NAME = :admin_featured_opportunity
    include Page
    include Database
  end

  class Edit
    SHORT_NAME = :admin_edit_featured_opportunity
    include Page
    include Database
    has_select(:conversation, 'featured_opportunity_conversation_id')
    has_select(:contribution, 'featured_opportunity_contribution_ids')
    has_select(:action, 'featured_opportunity_action_ids')
    has_select(:reflection, 'featured_opportunity_reflection_ids')
    has_button(:update, 'Update Featured opportunity', :admin_featured_opportunity)
  end

end
end
end
end
