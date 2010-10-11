require 'uri'
require 'cgi'

module PAUrlHelper

  def pa_new_issue_contribution_url(person, issue)
    pa_build_post_url("Contribution",
                      :issue_id => issue.id,
                      :person_id => person.id)
  end

  def pa_new_conversation_contribution_url(person, conversation_id,
                                           parent_contribution_id)
    pa_build_post_url("Contribution", :person_id => person.id,
                      :conversation_id => conversation_id,
                      :parent_contribution_id => parent_contribution_id)
  end

  protected

  def pa_build_post_url(blog_type, contrib_params={})
    params = {:blog_type => blog_type,
      :redirect => CGI.escape(create_from_pa_contributions_url(contrib_params))}
    params = params.map do |name, value|
      "#{name}=#{value}"
    end
    params = params.join("&") + (pa_authtoken('&') || "")

    "#{URI.join(Civiccommons::PeopleAggregator.URL, 'post_content.php')}?#{params}"
  end

end
