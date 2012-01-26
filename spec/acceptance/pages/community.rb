module CivicCommonsDriver
  module Pages
    class Community
      SHORT_NAME = :community_page
      include Page
    end
    
    class IssueCommunity
      SHORT_NAME = :issue_community       
      include Page  
      
      has_link(:people_and_organizations, 'People & Organizations', :issue_community)
      has_link(:people_only, 'People Only', :issue_community)
      has_link(:organizations_only, 'Organizations Only', :issue_community)
      
      has_link(:newest_members, 'Newest Members', :issue_community)
      has_link(:most_active, 'Most Active', :issue_community)
      has_link(:alphabetical, 'Alphabetical', :issue_community)
      
    end
  end
end
