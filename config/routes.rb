Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users do
    resources :properties
  end
  
  resources :regions do
  end
   
  resources :comunas do
  end
  
  resources :likes do
  end
  
  resources :dislikes do
  end
  
  resources :favourites do
  end
  
  resources :properties do
  end
  
  post 'auth/login', to: 'authentication#authenticate'
  
  post 'signup', to: 'users#create'
  
  
end
