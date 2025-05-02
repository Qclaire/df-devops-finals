Rails.application.routes.draw do
  get '/health', to: 'health#check'
  get '/chain', to: 'chain#forward'
end