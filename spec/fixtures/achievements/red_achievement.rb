class RedAchievement <  Achievements::Base
  class << self
    def observers?
      :Red
    end

    def expiration_date
      false
    end

    def expired?
      false
    end

    # Weather to skip execution of Achievement during a global rake execution
    def skip_rake?
      true
    end

    def earn_badge?(user)
      raise MethodNotDefinedError
    end

    def awards?
      raise MethodNotDefinedError
    end
  end
end

