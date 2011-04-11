module CCML
  module Tag

    class Base

      def initialize(opts = {})
        if opts.is_a?(Hash)
          @opts = opts
        else
          @opts = {}
        end
      end

      def index
        raise CCML::Error::NotImplementedError, "You must override the index method in all #{self.class} subclasses."
      end

    end

  end
end
