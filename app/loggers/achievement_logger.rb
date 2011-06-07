# Logger for Achievements
#
# Usage: AchievementLogger.logger.info "Data to log"
class AchievementLogger < Logger
  cattr_accessor :al_logger, :logfile

  class << self
    # Reset AchievementLogger class variables to defaults
    def reset
      @@logfile = set_logfile
      @@al_logger = AchievementLogger.new(logfile)
    end

    # Getter for logfile.  If undefined, default will be set
    def logfile
      @@logfile ||= set_logfile
    end

    # Setter for logfile.
    #
    # Default is Rails.root log/achievement.log
    def logfile=(location)
      set_logfile(location)
    end

    # Find or Create an Singleton instance of the AchievementLog
    def logger
      @@al_logger ||= AchievementLogger.new(logfile)
    end

    # Make setting logfile to itself easier to understand.
    def set_logfile(location="#{Rails.root}/log/achievement.log")
      log = File.open(location, 'a')
      log.sync = true
      @@logfile = log
    end

  end

  # Format log message
  def format_message(severity, timestamp, progname, msg)
    "#{timestamp.to_formatted_s(:db)} #{severity} #{msg}\n"
  end
end

