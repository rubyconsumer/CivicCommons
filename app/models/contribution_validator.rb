class ContributionValidator < ActiveModel::Validator
  
  def validate(record)
    record.errors[:parent] << "Regular Contributions must be added to existing Contributions" if top_level_or_parent_present?(record)
  end
  
  def top_level_or_parent_present?(record)
    record.class!=TopLevelContribution && record.parent.blank?
  end
end