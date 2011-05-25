module CCML
  module Tag

    class TagPair < Base

      attr_writer :tag_body

      IF_BLOCK_PATTERN = /\{if\s+.+?}.*?(\{if:elsif\s+.+?}.+?)*?(\{if:else}.+?)??\{\/if}/im
      IF_PATTERN = /\{if\s+(?<cond>.+?)}(?<body>.+?)\{\/?if/im
      ELSIF_PATTERN = /\{if:else?if\s+(?<cond>.+?)}(?<body>.+?)\{\/?if/im
      ELSE_PATTERN = /\{if:else}(?<body>.+?)\{\/if}/im
      VAR_PATTERN = /\{(?<vars>\S+?)(\s+format=['"](?<format>.*?)['"])?}/i
      ARRAY_PATTERN = /(?<method>\w+)(\[(?<index>\d+)\])/i

      def process_tag_body(data)

        # inputs and outputs
        return_data = ''
        data = [ data ] unless data.respond_to?(:each) and not data.is_a?(Hash)

        # iterate through all data items
        data.each do |datum|

          # wrap the hash for later evaluation
          datum = to_struct(datum) if datum.is_a?(Hash)

          # process the tag body
          tag_body = String.new(@tag_body.to_s)
          tag_body = process_conditionals(datum, tag_body)
          tag_body = process_variables(datum, tag_body)

          # append to the output buffer
          return_data << tag_body

        end

        return return_data
      end

      private

      def evaluate_conditional(datum, if_match, match, tag_body)
        sub = nil
        begin
          if datum.instance_eval(if_match[:cond])
            sub = if_match[:body]
            tag_body = tag_body.sub(match.to_s, sub)
          end
        rescue => error
          #puts "#{error.class} - #{error.message}"
        end
        return sub, tag_body
      end

      def process_conditionals(datum, tag_body)

        # iterate through all the conditionals in the tag body
        pos = 0
        while match = IF_BLOCK_PATTERN.match(tag_body, pos)

          # process the 'if' conditional
          if_match = IF_PATTERN.match(match.to_s)
          sub, tag_body = evaluate_conditional(datum, if_match, match, tag_body)

          # process all 'elsif' conditionals
          if sub.nil?
            pos = 0
            while if_match = ELSIF_PATTERN.match(match.to_s, pos)
              sub, tag_body = evaluate_conditional(datum, if_match, match, tag_body)
              sub ? break : pos = if_match.end(2)
            end
          end

          # process the else
          if sub.nil? and if_match = ELSE_PATTERN.match(match.to_s)
            sub = if_match[:body]
            tag_body = tag_body.sub(match.to_s, sub)
          end

          # wipe the entire match if no conditional returned true
          if sub.nil?
            sub = ''
            tag_body = tag_body.sub(match.to_s, sub)
          end

          # look for another match
          pos = match.begin(0) + sub.length
        end

        return tag_body
      end

      def process_variables(datum, tag_body)

        # iterate through all vars in the tag body
        pos = 0
        while match = VAR_PATTERN.match(tag_body, pos)

          # get the variable call string
          vars = match[:vars]
          # get the variable data
          begin
            methods = vars.split('.')
            object = datum
            (0 .. methods.size-1).each do |i|
              arymtch = ARRAY_PATTERN.match(methods[i])
              if arymtch.nil?
                object = object.send(methods[i].to_sym)
              else
                object = object.send(arymtch[:method].to_sym)
                object = object[arymtch[:index].to_i]
              end
            end
            sub = object
          rescue => error
            #puts "#{error.class} - #{error.message}"
            sub = nil
          end

          # check for date format
          if match[:format]
            begin
              sub = Time.parse(sub) unless sub.is_a?(Time)
              sub = sub.strftime(match[:format])
            rescue => error
              #puts "#{error.class} - #{error.message}"
            end
          end

          # make the substitution
          sub = sub.to_s
          tag_body = tag_body.sub(match.to_s, sub)

          # look for another match
          pos = match.begin(0) + sub.length
        end

        return tag_body
      end

      def to_struct(item)
        struct = OpenStruct.new(item)
        item.each do |key, value|
          if value.is_a? Hash
            obj = to_struct(value)
            struct.send("#{key}=".to_sym, obj)
          elsif value.is_a? Array
            value = struct.send(key.to_sym)
            (0 .. value.size-1).each do |i|
              value[i] = to_struct(value[i]) if value[i].is_a? Hash
            end
          end
        end
        return struct
      end
    end

  end
end
