module CCML
  module Error

    class Base < StandardError
      attr_reader :trace

      def initialize(message = nil)
        @trace = []
        if $!
          $!.trace.each {|e| @trace.push(e) } if $!.is_a?(CCML::Error::Base)
          @trace.push($!)
        end
        super(message)
      end

    end
  
  end
end
