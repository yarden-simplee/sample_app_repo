Rails.application.routes.draw do

  get 'password_resets/new'

  get 'password_resets/edit'

  get 'sessions/new'

  # For each get statement' the first arguement is the custom URL
  # relative to the home path. the 'to:' argument specifies 'controller_name#action_name'
  # The helpers 'arguement_path' and 'arguement_url' will be created for each entry according
  # to the first argument         

  root 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to:'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'
  post '/signup',  to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  # resources :users # This will make rails acknowledge requests made for Url '/users/id' as well as all other restful actions for the user resource
  resources :users do # Will generate URLs of the format '/users/1/following' and '/users/1/followers' 
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]

end


=begin 

The helpers generated for the 'users' resource:
	
	new_user_path, new_user_url - Create
	user_path, user_url - Read
	edit_user_path, edit_user_url - Update
	delete will be determined by going to the 'user_path' with a 'delete' http request

=end