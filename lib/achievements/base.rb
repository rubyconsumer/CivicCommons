module Achievements
  class Base
    class << self
      #def self.observers?
      #raise MethodNotDefinedError
      #end

      # If the achievement is expired then don't run it during global rake execution.
      def expiration_date
        raise MethodNotDefinedError
      end

      def expired?
        DateTime.now > expiration_date
      end

      # Weather to skip execution of Achievement during a global rake execution
      def skip_rake?
        raise MethodNotDefinedError
      end

      def earn_badge?(user)
        raise MethodNotDefinedError
      end

      def awards?
        raise MethodNotDefinedError
      end
    end
  end
end

