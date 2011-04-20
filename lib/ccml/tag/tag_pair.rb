module CCML
  module Tag

    private

    #--
    # A wrapper class for a Hash used in tag pair conditional processing.
    #++
    class HashWrapper
      def initialize(hash)
        @hash = hash
      end
      def method_missing(sym, *args, &block)
        if @hash.has_key?(sym)
          return @hash[sym]
        elsif @hash.has_key?(sym.to_s)
          return @hash[sym.to_s]
        else
          raise NameError, "undefined local variable or method '#{sym.to_s}' for #{@hash}"
        end
      end
    end

    public

    class TagPair < Base

      attr_writer :tag_body

      IF_BLOCK_PATTERN = /\{if\s+.+?}.*?(\{if:elsif\s+.+?}.+?)*?(\{if:else}.+?)??\{\/if}/im
      IF_PATTERN = /\{if\s+(?<cond>.+?)}(?<body>.+?)\{\/?if/im
      ELSIF_PATTERN = /\{if:else?if\s+(?<cond>.+?)}(?<body>.+?)\{\/?if/im
      ELSE_PATTERN = /\{if:else}(?<body>.+?)\{\/if}/im
      VAR_PATTERN = /\{(?<var>\w+)}/

      def process_conditionals
      end

      def process_variables(datum, tag_body)

        # iterate through all vars in the tag body
        match = VAR_PATTERN.match(tag_body)
        while match

          # get the variable name
          var = match[:var].to_sym

          # get the variable data
          begin
            sub = datum.send(var)
          rescue Exception => e
            sub = nil
          end

          # make the substitution
          sub = sub.to_s
          tag_body = tag_body.sub(match.to_s, sub)

          # look for another match
          pos = match.begin(0) + sub.length
          match = VAR_PATTERN.match(tag_body, pos)
        end

        return tag_body
      end

      def process_tag_body(data)

        # inputs and outputs
        return_data = ''
        data = [ data ] unless data.is_a?(Array)

        # iterate through all data items
        data.each do |datum|

          # wrap the hash for later evaluation
          datum = CCML::Tag::HashWrapper.new(datum) if datum.is_a?(Hash)

          # refresh the tag body
          tag_body = String.new(@tag_body.to_s)

          # iterate through all the conditionals in the tag body
          match = IF_BLOCK_PATTERN.match(tag_body)
          while match
            
            found = false

            # process the 'if' conditional
            if_match = IF_PATTERN.match(match.to_s)
            begin
              if datum.instance_eval(if_match[:cond])
                sub = if_match[:body]
                tag_body.sub!(match.to_s, sub)
                found = true
              end
            rescue
              # continue
            end

            # process all 'elsif' conditionals
            if not found
              if_match = ELSIF_PATTERN.match(match.to_s)
              while if_match
                begin
                  if datum.instance_eval(if_match[:cond])
                    sub = if_match[:body]
                    tag_body.sub!(match.to_s, sub)
                    found = true
                    break
                  end
                rescue
                  # continue
                end
                pos = if_match.end(2)
                if_match = ELSIF_PATTERN.match(match.to_s, pos)
              end
            end

            # process the else
            if not found
              if if_match = ELSE_PATTERN.match(match.to_s)
                sub = if_match[:body]
                tag_body.sub!(match.to_s, sub)
                found = true
              end
            end

            # wipe the entire match if no conditional is true
            if not found
              sub = ''
              tag_body.sub!(match.to_s, sub)
            end

            # look for another match
            pos = match.begin(0) + sub.length
            match = IF_BLOCK_PATTERN.match(tag_body, pos)
          end

          tag_body = process_variables(datum, tag_body)

          # append to the output buffer
          return_data << tag_body

        end

        return return_data
      end

    end
  end
end
