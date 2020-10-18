Rails.application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  get  'auth/:provider/callback' => 'sessions#create'
  post 'logout' => 'sessions#destroy'
  get  'auth/failure' => 'sessions#failure'
  get  'auth/twitter', :as => 'login'
  
  get '/movies/search_tmdb' => 'movies#search_tmdb'
  post '/movies/createfromtmdb' => 'movies#create_from_tmdb', :as => 'createfromtmdb'
  
  resources :movies do
    resources :reviews
  end
  root :to => redirect('/movies')

  
  

end
