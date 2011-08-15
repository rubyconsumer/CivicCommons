module SurveysHelper
  def relative_weighted_votes_percentage(weighted_votes_percentage, highest_weighted_votes_percentage, offset=0)
    total = (weighted_votes_percentage.to_f / highest_weighted_votes_percentage.to_f) * 100
    total = total + offset if total > offset.abs
    return total.to_i
  end
end