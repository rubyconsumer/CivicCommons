class ContributionValidator < ActiveModel::Validator
  
  def validate(record)
    record.errors[:parent] << "Regular Contributions must be added to existing Contributions" if top_level_or_parent_present?(record)
    record.errors[:content] << "Contribution cannot be blank" unless content_not_blank_or_link_or_embedded_snippet?(record)
  end
  
  def top_level_or_parent_present?(record)
    record.class!=TopLevelContribution && record.parent.blank?
  end
  
  def content_not_blank_or_link_or_embedded_snippet?(record)
    !record.content.blank? || record.class==Link || record.class==EmbeddedSnippet
  end
end