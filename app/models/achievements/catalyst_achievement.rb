# Catalyst:
#   Irrevocable badge
#   Awarded for starting one conversation
#   +5 reputation
class CatalystAchievement < Achievements::Base
  cattr_accessor :achievement_metadata

  class << self

    def achievement_metadata
      @@achievement_metadata ||= begin
        AchievementMetadata.where(:title => 'Catalyst').first
      end
    end

    def observers?
      :Conversation
    end

    def has_award?(conversation_model)
      AchievementEarned.where(:person_id => conversation_model.owner, :achievement_metadata_id => achievement_metadata.id).first
    end

    def awards?(conversation_model)
      Rails.logger.info "*** CatalystAchievement.awards?"
      Rails.logger.info "    * model.id:#{conversation_model.id}"
      Rails.logger.info "    * model:#{conversation_model.inspect}"

      person = conversation_model.owner
      {@@achievement_metadata.id => [person]} unless has_award?(conversation_model)
    end

  end
end

