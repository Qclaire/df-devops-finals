Rails.application.configure do
  
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true
  config.server_timing = true
  
  
  
  config.hosts << /.*\.elb\.amazonaws\.com/

  
  config.active_support.deprecation = :log
  
  
  config.active_support.disallowed_deprecation = :raise
  
  
  config.active_support.disallowed_deprecation_warnings = []
  
  
  
end