Rails.application.configure do
  
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  
  
  
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?
  
  
  
  
  
  config.log_tags = [ :request_id ]
  
  
  config.active_support.deprecation = :notify
  
  
  config.active_support.disallowed_deprecation = :log
  
  
  config.active_support.disallowed_deprecation_warnings = []
end