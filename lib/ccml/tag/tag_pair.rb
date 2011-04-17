module CCML
  module Tag
    class TagPair < Base

      attr_writer :tag_body

      def process_tag_body(data)

        # inputs and outputs
        return_data = ''
        data = [ data ] unless data.is_a?(Array)

        # iterate through all data items
        data.each do |datum|

          # refrest the tag body
          tag_body = @tag_body

          # get all variables from the tag data
          pattern = /\{(?<var>\w+)}/
          match = pattern.match(tag_body)

          # iterate through all vars in the tag body
          while match

            # get the variable name
            var = match[:var].to_sym

            # get the variable data
            if datum.is_a?(Hash)
              sub = datum[var]
            elsif datum.respond_to?(var)
              sub = datum.send(var)
            end

            # make the substitution
            sub = sub.to_s
            tag_body = tag_body.sub(match.to_s, sub)

            # look for another match
            pos = match.begin(0) + sub.length
            match = pattern.match(tag_body, pos)

          end

          # append to the output buffer
          return_data << tag_body

        end

        return return_data
      end

    end
  end
end
