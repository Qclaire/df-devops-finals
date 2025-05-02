require "logger"
require_relative "boot"

require "rails"

require "action_controller/railtie"


Bundler.require(*Rails.groups)

module MinimalRailsApi
  class Application < Rails::Application
    
    config.load_defaults 7.0
    
    
    config.middleware.delete Rack::Sendfile
    config.middleware.delete ActionDispatch::Static
    
    
    config.api_only = true
    
    
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end
end