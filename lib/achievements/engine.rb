module Achievements
  class Engine
    cattr_accessor :achievements

    class << self
      def startup
        AchievementLogger.logger.info "********************************************************************************"
        AchievementLogger.logger.info "* Achievement Engine Starting Up..."

        @@achievements = []
        load_achievements

        AchievementLogger.logger.info "* Achievements Directory:"
        AchievementLogger.logger.info "* * #{Achievements::Directory.list_directory}"
        AchievementLogger.logger.info "********************************************************************************"
      end

      # For a given path, load all the achievements into the Achievements Directory
      def load_achievements(directory="#{Rails.root}/app/models/achievements")
        AchievementLogger.logger.info "* * loading achievements into directory"
        AchievementLogger.logger.info "*   * Directory to look up:"
        AchievementLogger.logger.info "*     * #{directory}"

        file_list = Dir.glob(directory + "/*_achievement.rb")
        @@achievements = Achievements::Directory

        AchievementLogger.logger.info "*   * Registering files:"
        file_list.each do |file|
          AchievementLogger.logger.info "*     * #{file}"
        end

        file_list.each do |achievement_file|
          register_achievement(achievement_file)
        end
        @@achievements.list_directory
      end

      # Register the achivement with the AchivementDirectory
      def register_achievement(achievement_file)
        AchievementLogger.logger.info "*   * Registering achievement"
        AchievementLogger.logger.info "*     * file:#{achievement_file}."

        file_basename, class_name, klass = get_achievement(achievement_file)
        observers = klass.observers?
        AchievementLogger.logger.info "*     * file basename:#{file_basename}."
        AchievementLogger.logger.info "*     * class name:#{class_name}."
        AchievementLogger.logger.info "*     * klass:#{klass}."
        AchievementLogger.logger.info "*     * observers:#{observers}."
        Directory.add_achievement(class_name, observers)
      end

      # Get Achievement Information based off of the achivement file name.
      def get_achievement(achievement_file)
        file_basename = File.basename(achievement_file)

        klass_name = file_basename.gsub(/.rb$/, "").classify
        klass = Kernel.const_get(klass_name)

        return file_basename, klass_name, klass
      end

      # Execute the achievements.
      # Called by:
      # * rake task
      # * observable
      #
      # Parameters:
      # * model - expects an instance of a model that is being observed
      # * type - (optional) - what type of model action.  defaults to :default
      def execute(model, type=:default)
        AchievementLogger.logger.info "================================================================================"
        AchievementLogger.logger.info "= Achievements::Engine.execute triggered."
        AchievementLogger.logger.info "= * model:#{model}"
        AchievementLogger.logger.info "= * type:#{type}"

        #model_klass = model.is_a?(Achievements::AchievementsBase) ? model.class.to_s.to_sym : model.class.to_sym
        model_klass = model.class.to_s.to_sym
        type = type.to_sym

        AchievementLogger.logger.info "= * Post Processed:"
        AchievementLogger.logger.info "=   * model:#{model_klass}"
        AchievementLogger.logger.info "=   * model id:#{model.id}"
        AchievementLogger.logger.info "=   * type:#{type}"

        AchievementLogger.logger.info "= * Achievements Directory:"
        AchievementLogger.logger.info Achievements::Directory.list_directory.inspect

        Achievements::Directory.lookup_by_model(model_klass, type).each do |achievement|
          AchievementLogger.logger.info "= * Getting awards for achievement:#{achievement}"
          klass = Kernel.const_get(achievement)
          awards = klass.awards?(model)

          AchievementLogger.logger.info "=   * klass:#{klass}"
          AchievementLogger.logger.info "=   * awards:#{awards}"
          process_awards(achievement, awards)
        end
        AchievementLogger.logger.info "================================================================================"
      end

      # Go through the list of achievement awards and award them to users
      #
      # If the list of awards is like an array send them through to award_achievements.
      # Otherwise, treat the awards as a hash, and use the key as the award name and the values as the recipients.
      def process_awards(achievement, awards)
        AchievementLogger.logger.info "=   * Achievements::Engine.process_awards"
        AchievementLogger.logger.info "=     * achievement:#{achievement}"
        AchievementLogger.logger.info "=     * awards:#{awards}"


        if awards.respond_to?(:pop) # Awards is like an Array
          process_awards_array(achievement, awards)
        else # Assume Awards is a Hash
          return nil if awards.blank? || !awards.respond_to?(:keys)
          achievement_metadata_ids = awards.keys
          achievement_metadata_ids.each do |achievement_metadata_id|
            award_achievements(achievement_metadata_id, awards[achievement_metadata_id])
          end
        end
      end

      def process_awards_array(achievement, awards)
        AchievementLogger.logger.info "=     * Achievements::Engine.process_awards_array"
        return nil if awards.size == 0

        achievement_metadata_result = AchievementMetadata.where(:title => achievement).all

        if achievement_metadata_result.size == 1
          achievement_metadata_id = achievement_metadata_result.first.id
        elsif achievement_metadata_result.size == 0
          raise Achievements::AchievementNotFoundError, "Zero achievements found called:#{achievement}."
        else
          AchievementLogger.logger.error " THERE WAS A PROBLEM.  WE FOUND MORE THAN ONE ACHIEVEMENT WITH THE SAME NAME:#{achievement}"
          AchievementLogger.logger.error " we found #{achievement_metadata_result.size} results."
          AchievementLogger.logger.error " #{achievement_metadata_result}."

          raise Achievements::MultipleAchievementsFoundError, "multiple achievements found called:#{achievement}."
        end

        AchievementLogger.logger.info "=      * achievement_metadata_id:#{achievement_metadata_id}"

        award_achievements(achievement_metadata_id, awards) unless achievement_metadata_id.blank?
      end

      # Awards users with an achievement.
      #
      # users_awarded is treated as an array.
      def award_achievements(achievement_metadata_id, users_awarded)
        AchievementLogger.logger.info "   *** Achievements::Engine.award_achievements"
        AchievementLogger.logger.info "       * achievement_metadata_id:#{achievement_metadata_id}"
        AchievementLogger.logger.info "       * users_awards:#{users_awarded}"
        # Iterate through the users_awarded list
        # * add them to the database
        #   # Name of Achievement
        #   # Points Awarded(?) we can get this from the achievement.  So let's get the achievement id.
        #   # time data stampe awarded
        #
        users_awarded.each do |user|
          begin
            AchievementEarned.create(:person_id => user.id, :achievement_metadata_id => achievement_metadata_id)
          rescue ActiveRecord::RecordInvalid => ri
            AchievementLogger.logger.error "RecordInvalid: person:#{user.id} achievement_metadata:#{achievement_metadata_id}."
            AchievementLogger.logger.error ri.inspect
          rescue StandardError => e
            AchievementLogger.logger.error "StandardError: person:#{user.id} achievement_metadata:#{achievement_metadata_id}."
            AchievementLogger.logger.error e.inspect
          end
        end
      end

    end

  end
end

















