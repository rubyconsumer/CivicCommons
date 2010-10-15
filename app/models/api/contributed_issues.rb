class Api::ContributedIssues

  def self.for_person_by_people_aggregator_id(people_aggregator_id, request)
    person = Person.find_by_people_aggregator_id(people_aggregator_id)
    for_person(person, request)
  end


  def self.for_person(person, request)
    issues = person.contributed_issues

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
  end

end

