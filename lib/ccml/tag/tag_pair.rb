module CCML
  module Tag
    class TagPair < Base

      attr_writer :tag_data

      def process_tag_data(data)
        raise CCML::Error::NotImplementedError, "#{self.class}::process_tag_data is not yet implemented."
      end

    end
  end
end
