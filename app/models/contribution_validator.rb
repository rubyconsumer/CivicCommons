class ContributionValidator < ActiveModel::Validator
  
  def validate(record)
    record.errors[:parent] << "Regular Contributions must be added to existing Contributions" if record.class!=TopLevelContribution && record.conversation.blank? && record.parent.blank?
  end
end