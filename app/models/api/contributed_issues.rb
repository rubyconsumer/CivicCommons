class Api::ContributedIssues

  def self.for_person_by_email(email)
    person = Person.find_by_email(email)
    for_person(person)
  end


  def self.for_person(person)
    issues = person.contributed_issues

    issues.map do |issue|
      {
        name: issue.name,
        summary: issue.summary,
        participant_count: issue.participants.count,
        contribution_count: issue.contributions.where(owner: person).count
      }
    end
  end

end

