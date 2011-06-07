# Catalyst:
#   Irrevocable badge
#   Awarded for starting one conversation
#   +5 reputation
class CatalystAchievement < Achievements::Base
  class << self

    def observers?
      :Conversation
    end

    def awards?(model=nil)
      Rails.logger.info "*** CatalystAchievement.awards?"
      Rails.logger.info "    * model.id:#{model.id}"
      Rails.logger.info "    * model:#{model.inspect}"
      [Person.find(2)]
    end

  end
end

