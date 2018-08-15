Rails.application.routes.draw do

  # For each get statement' the first arguement is the custom URL
  # relative to the home path. the 'to:' argument specifies 'controller_name#action_name'
  # The helpers 'arguement_path' and 'arguement_url' will be created for each entry according
  # to the first argument         

  root 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to:'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'

end
