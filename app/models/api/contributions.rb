class Api::Contributions

  def self.for_person_by_people_aggregator_id(people_aggregator_id, request)
    person = Person.find_by_people_aggregator_id(people_aggregator_id)

    if person
      for_person(person, request)
    else
      Rails.logger.warn("Person not found by PA ID in Api::Contributions.for_person_by_people_aggregator_id for:#{people_aggregator_id}.  Called with Request:#{request}")
      nil
    end
  end


  def self.for_person(person, request)
    contributions = person.contributions

    contributions.map do |contribution|
      contribution = ContributionPresenter.new(contribution, request)
      {
        parent_title: contribution.parent_title,
        parent_type: 'conversation',
        parent_url: contribution.parent_url,
        created_at: contribution.created_at,
        content: contribution.content,
        attachment_url: '',
        embed_code: contribution.embed_target.to_s,
        type: contribution.contribution_type,
        link_text: '',
        link_url: contribution.url.to_s
      }
    end
  end

end

