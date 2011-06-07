module Achievements
  class Directory
    cattr_accessor :achievements
    @@achievements = {}

    class << self
      # Parameters
      # * achivement is the class of the achievement
      # * model, what model is being observed
      #   * default is executed on demand.  Typically by a rake task
      # * type is if the achievement observes a create, update or any action of a model
      #   * archievements with a default type will display with all other types. It's considered a wildtype.
      def add_achievement(achievement, model, type=nil)
        AchievementLogger.logger.info "*     * Add Achievement:#{achievement} Model:#{model} Type:#{type}."

        type ||= :default
        model ||= :default
        @@achievements[model].blank? ? @@achievements.merge!(model => {}) : ""
        @@achievements[model][type].blank? ? @@achievements[model][type] = [achievement] : @@achievements[model][type] << achievement
      end

      def lookup_by_model(model, type=nil)
        type ||= :default
        return [] if @@achievements[model].blank?
        if @@achievements[model][type]
          if type == :default
            @@achievements[model][type]
          else
            @@achievements[model][type] + self.lookup_by_model(model)
          end
        else
          []
        end
      end

      def list_directory
        @@achievements
      end
    end
  end
end


