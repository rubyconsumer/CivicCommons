require 'uri'
require 'cgi'

module PAUrlHelper

  def pa_new_issue_contribution_url(person, issue)
    pa_build_post_url("Contribution",
                      :issue_id => issue.id,
                      :person_id => person.id,
                      :title => issue.name)
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
