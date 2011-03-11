class PresenterForm < PresenterBase
  extend ActiveModel::Naming

  def to_model; self end

end
