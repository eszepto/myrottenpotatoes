Rails.application.routes.draw do
  get  'auth/:provider/callback' => 'sessions#create'
  post 'logout' => 'sessions#destroy'
  get  'auth/failure' => 'sessions#failure'
  get  'auth/twitter', :as => 'login'
  
  resources :movies
  root :to => redirect('/movies')

  
end
