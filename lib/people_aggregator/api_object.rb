module PeopleAggregator
  module ApiObject
    extend ActiveSupport::Concern


    included do |base|
      class << base; attr_accessor :allowed_keys end
    end

    module ClassMethods
      def attr_allowable(*keys)
        @allowed_keys ||= []
        @allowed_keys << keys
        @allowed_keys.flatten!
      end
    end


    def initialize(attrs={})
      attrs.symbolize_keys!

      allowed_keys.each do |k|
        self.class.send(:attr_accessor, k)
        self.instance_variable_set("@#{k}", attrs[k])
      end

      keys_not_allowed = attrs.keys - allowed_keys

      unless keys_not_allowed.empty?
        raise ArgumentError, "Keys #{keys_not_allowed.to_sentence} are not defined as an allowed attribute."
      end

      @attrs = attrs
    end

    def allowed_keys
      self.class.allowed_keys || []
    end

  end
end
