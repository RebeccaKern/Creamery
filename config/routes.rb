Rails.application.routes.draw do
  # Routes for main resources
  resources :stores
  resources :employees
  resources :assignments
  resources :shifts
  get 'shift_start/' => 'shifts#start_shift', as: :start_shift
  #post 'shift_start/' => 'shift#start_shift', as: :start_shift

  resources :jobs
  resources :flavors
  # this will need to be fixed##############################
  resources :store_flavors
  # Toggling for store flavors
  post 'toggle_flavors/' => 'store_flavors#toggle', as: :add_flavors
  delete 'toggle_flavors/' => 'store_flavors#toggle', as: :remove_flavors

  # Semi-static page routes
  get 'home' => 'home#home', as: :home
  get 'about' => 'home#about', as: :about
  get 'contact' => 'home#contact', as: :contact
  get 'privacy' => 'home#privacy', as: :privacy

  resources :users
  resources :sessions
  get 'user/edit' => 'users#edit', :as => :edit_current_user
  get 'signup' => 'users#new', :as => :signup
  get 'login' => 'sessions#new', :as => :login
  get 'logout' => 'sessions#destroy', :as => :logout
  
  # Set the root url
  root :to => 'home#home'  
  
end
