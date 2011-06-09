module Achievements
  class Base
    class << self
      #def self.observers?
      #  raise NotImplementedError
      #end

      # If the achievement is expired then don't run it during global rake execution.
      def expiration_date
        raise NotImplementedError, "Please implement the method: expiration_date"
      end

      def expired?
        DateTime.now > expiration_date
      end

      # Weather to skip execution of Achievement during a global rake execution
      def skip_rake?
        raise NotImplementedError, "Please implement the method: skip_rake?"
      end

      def earn_badge?(user)
        raise NotImplementedError, "Please implement the method: earn_badge?"
      end

      def awards?
        raise NotImplementedError, "Please implement the method: awards?"
      end
    end
  end
end

