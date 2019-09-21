Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  # line api
  post '/callback' => 'message#callback'
  
  # session
  get '/' => 'session#new', as: "new_session"
  post '/login' => 'session#create', as: "create_session"
  post '/logout' => 'session#destroy', as: "destroy_session"
  
  # fest
  get '/fests' => 'fests#index', as: "fests"
  get '/fests/new' => 'fests#new' , as: "new_fest"
  get '/fests/:id' => 'fests#show' , as: "fest"
  get '/fests/:id/edit' => 'fests#edit' , as: "edit_fest"
  post '/fests' => 'fests#create'
  patch '/fests' => 'fests#create'
  post '/fests/:id' => 'fests#update'
  patch '/fests/:id' => 'fests#update'
  post '/fests/:id/totalize' => 'fests#totalize'
  
  # fest_vote
  post '/fests/:id/fest_vote' => 'fest_votes#create', as: "create_fest_vote"
  get '/fest_votes/:id/edit' => 'fest_votes#edit', as: "edit_fest_vote"
  post '/fest_votes/:id' => 'fest_votes#update', as: "update_fest_vote"
  
end
