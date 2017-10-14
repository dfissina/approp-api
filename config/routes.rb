Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users do
    resources :properties
  end
  
  #resources :properties do    
  #end
  
  post 'auth/login', to: 'authentication#authenticate'
  
  post 'signup', to: 'users#create'
end
