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
          #if_pattern = /\{if.*?}.*?\{\/if}/im
          if_pattern = /\{if\s+.+?}.*?(\{if:elsif\s+.+?}.+?)*?(\{if:else}.+?)??\{\/if}/im

          # iterate through all the conditionals in the tag body
          match = if_pattern.match(tag_body)
          while match
#p match
puts "!!!!! #{match.to_s} !!!!!"

            # process the 'if'
            if_match = /\{if\s+(?<cond>.+?)}(?<body>.+?)\{\/?if/im.match(match.to_s)
puts "IF (#{match.size})----->"
p if_match

            # process all 'elsif'
            elsif_match = /\{if:elsif\s+(?<cond>.+?)}(?<body>.+?)\{\/?if/im.match(match.to_s)
            while elsif_match
puts "ELSIF (#{match.size})----->"
p elsif_match
              pos = elsif_match.end(2)
              elsif_match = /\{if:elsif\s+(?<cond>.+?)}(?<body>.+?)\{\/?if/im.match(match.to_s, pos)
            end
            # process the else
            else_match = /\{if:else}(?<body>.+?)\{\/if}/im.match(match.to_s)
puts "ELSE (#{match.size})----->"
p else_match

            # look for another match
match = nil
          end

          # iterate through all vars in the tag body
          var_pattern = /\{(?<var>\w+)}/
          match = var_pattern.match(tag_body)
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
            match = var_pattern.match(tag_body, pos)
          end

          # append to the output buffer
          return_data << tag_body

        end

        return return_data
      end

      private

      def process_conditionals(datum, tag_body)

        #if_pattern = /\{if\s+.+?}.+?\{\/if}/im
        if_pattern = /\{if\s+(?<cond>.+?)}.+?\{\/if}/im
        #match = /(\{if\s+(?<if_cond>.*?)})(?<if>.*?)(\{if:else})(?<else>.*?)(\{\/if})/im.match(c)

      end

    end
  end
end
