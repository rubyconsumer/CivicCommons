module OrganizationsHelper
  def organization_membership_button(organization, user)
    if organization.has_member?(user)
      raw content_tag(:p, (link_to "Leave this organization", remove_membership_user_path(organization.id),  :remote => true, :method => :delete, :class=>'button remove'), :class=>'membership')
    else
      raw content_tag(:p, (link_to "I'm affiliated with this organization", join_as_member_user_path(organization.id), :class=>'button join'), :class=>'membership')
    end
  end
end
