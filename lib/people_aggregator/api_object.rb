module PeopleAggregator
  module ApiObject
    extend ActiveSupport::Concern


    included do |base|
      class << base; attr_accessor :allowed_keys end
      base.instance_variable_set("@allowed_keys", [])
    end

    module InstanceMethods

      def initialize(attrs)

        attrs.symbolize_keys!

        @attrs =
          attrs.each do |k,v|
            if self.class.allowed_keys.include?(k)
              self.class.send(:attr_accessor, k.to_sym)
              self.instance_variable_set("@#{k}", v)
            else
              raise ArgumentError, "Key #{k} is not defined as an allowed attribute."
            end
          end
      end

    end


    module ClassMethods

      def attr_allowable(*keys)
        @allowed_keys << keys
        @allowed_keys.flatten!
      end

    end


  end
end
