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

    end
  end

end
