class Api::Contributions

  def self.for_person_by_id(person_id, request)
    begin
      person = Person.find(person_id)
      if person
        contributions = person.contributions.order('contributions.created_at DESC')

        contributions.map do |contribution|
          contribution = ContributionPresenter.new(contribution, request)
          {
            parent_title: contribution.parent_title,
            parent_type: 'conversation',
            parent_url: contribution.parent_url,
            created_at: contribution.created_at,
            content: contribution.content,
            attachment_url: contribution.attachment_url,
            embed_code: contribution.embed_target.to_s,
            type: contribution.contribution_type,
            link_text: contribution.url_title,
            link_url: contribution.url.to_s
          }
        end
      end
    rescue
      Rails.logger.warn("Person not found by ID in Api::Contributions.for_person_by_id for:#{person_id}.  Called with Request:#{request}")
      nil
    end
  end

end
