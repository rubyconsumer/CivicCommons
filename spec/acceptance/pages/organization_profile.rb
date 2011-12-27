module CivicCommonsDriver
  class OrganizationProfile
    SHORT_NAME= :organization_profile
    include Page

    def initialize options
      @slug = options[:for].cached_slug
    end

    def has_pluralized_itself?
      has_content? "Conversations We Are Following" and
      has_content? "Issues We Are Following" and
      has_content? "Our Recent Activity"
    end

    def has_contact_info_for? organization
      has_content? organization.organization_detail.city and
      has_content? organization.organization_detail.street and
      has_content? organization.organization_detail.postal_code and
      has_content? organization.organization_detail.region and
      has_content? "#{organization.organization_detail.phone}" and
      has_link? "Website", href: organization.website and
      has_link? "Facebook", href: organization.organization_detail.facebook_page and
      has_link? "@#{organization.twitter_username}"
    end

    def url
      "/user/#{@slug}"
    end
  end
end
