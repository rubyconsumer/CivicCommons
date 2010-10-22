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
        parent_image: contribution.parent_image.url(:panel),
        parent_image_width: contribution.parent.geometry_for_style(:panel).width.to_i,
        parent_image_height: contribution.parent.geometry_for_style(:panel).height.to_i,
        comment: contribution.content,
        participant_count: contribution.parent.participants.count,
        contribution_count: contribution.parent.contributions.where(owner: person).count,
        parent_url: contribution.parent_url
      }
    end
  end

end

