class Api::ContributedIssues

  def self.for_person_by_id(person_id, request)
    person = Person.find(person_id)
    if person
      issues = person.contributed_issues.order('created_at DESC')

      issues.map do |issue|
        issue = IssuePresenter.new(issue, request)
        {
          name: issue.name,
          summary: issue.summary,
          image: issue.image.url(:panel),
          image_width: issue.geometry_for_style(:panel).width.to_i,
          image_height: issue.geometry_for_style(:panel).height.to_i,
          participant_count: issue.participants.count,
          contribution_count: issue.contributions.where(owner: person).count,
          url: issue.url
        }
      end
    else
      Rails.logger.warn("Person not found by ID in Api::ContributedIssues.for_person_by_id for:#{person_id}.  Called with Request:#{request}")
      nil
    end
  end

end