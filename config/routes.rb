Rails.application.routes.draw do
  get 'sessions/create'

  get 'sessions/destroy'

  get 'users/index'

  get 'users/show'

  get 'users/new'

  get 'users/edit'

  get 'users/create'

  get 'users/update'

  get 'users/destroy'

  get 'students/index'

  get 'students/show'

  get 'students/new'

  get 'students/edit'

  get 'students/create'

  get 'students/update'

  get 'students/destroy'

  get 'registrations/index'

  get 'registrations/show'

  get 'registrations/new'

  get 'registrations/edit'

  get 'registrations/create'

  get 'registrations/update'

  get 'registrations/destroy'

  get 'families/index'

  get 'families/show'

  get 'families/new'

  get 'families/edit'

  get 'families/create'

  get 'families/update'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # Semi-static page routes
  # get 'home', to: 'home#index', as: :home
  get 'home/about', to: 'home#about', as: :about
  get 'home/contact', to: 'home#contact', as: :contact
  get 'home/privacy', to: 'home#privacy', as: :privacy
  get 'home/search', to: 'home#search', as: :search


  # Routes for main resources
  resources :curriculums
  resources :instructors
  resources :camps
  resources :families
  resources :students
  resources :locations
  resources :users
  # resources :registrations
  resources :sessions

  # Authentication routes
  resources :sessions
  resources :users
  # get 'users/new', to: 'users#new', as: :signup
  # get 'user/edit', to: 'users#edit', as: :edit_current_user
  get 'login', to: 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout

    # get 'registered_students', to: 'users#registered_students', as: :registered_students
  # Routes for managing camp instructors
  get 'camps/:id/instructors', to: 'camps#instructors', as: :camp_instructors
  post 'camps/:id/instructors', to: 'camp_instructors#create', as: :create_instructor
  delete 'camps/:id/instructors/:instructor_id', to: 'camp_instructors#destroy', as: :remove_instructor


  get "view_cart" => "registrations#view_cart", as: :view_cart
  get "pay" => "registrations#pay", as: :pay

  post "registrations" => "registrations#add_to_cart", as: :registrations

  get "remove_from_cart" => "registrations#remove_from_cart", as: :remove_from_cart
  post "checkout" => "registrations#checkout", as: :checkout


  # You can have the root of your site routed with 'root'
  root :to=> 'home#index', :as =>:home
end
