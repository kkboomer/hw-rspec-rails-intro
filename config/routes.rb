Rails.application.routes.draw do
  resources :movies
  root :to => redirect('/movies')
  post '/search', to: 'movies#search_tmdb', as: 'search_tmdb'
end
