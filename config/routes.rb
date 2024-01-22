Rails.application.routes.draw do
  get 'forecasts/show'
  ## ROOT PATH
  root 'forecasts#show'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
