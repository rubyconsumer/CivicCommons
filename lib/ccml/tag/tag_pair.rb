module CCML
  module Tag
    class TagPair < Base
      def initialize(opts, url = nil)
        raise CCML::Error::NotImplementedError, "#{self.class} is not yet implemented."
      end
    end
  end
end
