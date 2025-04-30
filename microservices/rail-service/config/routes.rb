Rails.application.routes.draw do
  get '/health', to: 'chain#health'
  get '/chain', to: 'chain#chain'
end
