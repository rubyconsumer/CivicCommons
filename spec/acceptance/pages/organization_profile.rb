module CivicCommonsDriver
  class OrganizationProfile
    SHORT_NAME= :organization_profile
    include Page

    def initialize options
      @slug = options[:for].cached_slug
    end

    def has_pluralized_itself?
      has_content? "Conversations we are following" and
      has_content? "Issues we are following" and
      has_content? "Our recent activity"
    end

    def has_contact_info_for? organization
      has_content? organization.organization_detail.city and
      has_content? organization.organization_detail.street_address and
      has_content? organization.organization_detail.postal_code and
      has_content? "P: #{organization.organization_detailphone}" and
      has_content? organization.organization_detail.region and
      has_link? "Organization Website", href: organization.website and
      has_link? "Organization Facebook Profile", href: organization.organization_detail.facebook_page and
      has_link? "Organization Twitter Profile", href: organization.twitter_username
    end

    def url
      "/organization/#{@slug}"
    end
  end
end
