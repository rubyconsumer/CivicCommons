class RatingGroupValidator < ActiveModel::Validator

  def validate(record)
    record.errors[:person] << "Author cannot rate own contribution" if person_is_author?(record)
  end

  def person_is_author?(record)
    record.contribution.owner == record.person_id
  end
end
