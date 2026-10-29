Rails.application.routes.draw do
  resources :movies
  root :to => redirect('/movies')
  get '/search', to: 'movies#search_tmdb', as: 'search_tmdb'
  post '/add_movie', to: 'movies#add_movie', as: 'add_movie'
end
