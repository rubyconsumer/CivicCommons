if !defined?(Civiccommons::Config)

  module Civiccommons
    class ConfigNotFoundError < ArgumentError; end

    class Config
      CC_CONFIG = YAML.load_file(File.join(Rails.root, "config", "civic_commons.yml"))

      CC_CONFIG[Rails.env].each do |key|
        (class << self; self; end).class_eval do
          define_method key[0] do |*args|
            if key[1].is_a?(Hash)
              key[1].default_proc = Proc.new do
                raise Civiccommons::ConfigNotFoundError, "Configuration requested was not found."
              end
              key[1]
            else
              key[1]
            end
          end
        end
      end

      def self.setup_default_email
        raise Civiccommons::ConfigNotFoundError, "Please set up the default email address. See the civic_commons.yml.sample for an example." unless self.respond_to?('default_email')
      end

      def self.validate_intercept_config
        raise Civiccommons::ConfigNotFoundError, "Please set up the mailer intercept config. See the civic_commons.yml.sample for an example." unless self.mailer.key?('intercept')
      end

      def self.setup_intercept_email
        self.mailer['intercept_email'] = self.default_email unless self.mailer.key?('intercept_email')
      end

      setup_default_email
      validate_intercept_config
      setup_intercept_email
    end
  end

end
