class Api::ContributedIssues

  def self.for_person_by_email(email, request)
    person = Person.find_by_email(email)
    for_person(person, request)
  end


  def self.for_person(person, request)
    issues = person.contributed_issues

    issues.map do |issue|
      issue = IssuePresenter.new(issue, request)
      {
        name: issue.name,
        summary: issue.summary,
        image: issue.image.url(:thumb),
        image_width: issue.geometry_for_style(:thumb).width.to_i,
        image_height: issue.geometry_for_style(:thumb).height.to_i,
        participant_count: issue.participants.count,
        contribution_count: issue.contributions.where(owner: person).count,
        url: issue.url
      }
    end
  end

end

