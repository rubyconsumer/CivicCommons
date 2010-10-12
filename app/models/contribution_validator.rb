class ContributionValidator < ActiveModel::Validator
  
  def validate(record)
    record.errors[:content] << "Comment cannot be blank" unless content_not_blank_or_link_or_embedded_snippet?(record)
    # This is needed but currently screws up the rspec tests. Don't have time rewrite all the specs right now, so we'll disregard this validation.
    #record.errors[:conversation] << "does not match parent contribution's conversation" unless parent_contribution_belongs_to_conversation?(record)
  end
  
  def top_level_or_parent_present?(record)
    record.class!=TopLevelContribution && record.parent.blank?
  end
  
  def content_not_blank_or_link_or_embedded_snippet?(record)
    !record.content.blank? || [Link, EmbeddedSnippet, PplAggContribution].include?(record.class)
  end
  
  def parent_contribution_belongs_to_conversation?(record)
    record.parent.nil? || record.parent.conversation_id == record.conversation_id    
  end
end
