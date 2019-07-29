Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  post '/callback' => 'message#callback'
  
  get '/fests' => 'fests#index', as: "fests"
  get '/fests/new' => 'fests#new' , as: "new_fest"
  get '/fests/:id' => 'fests#show' , as: "fest"
  get '/fests/:id/edit' => 'fests#edit' , as: "edit_fest"
  post '/fests' => 'fests#create'
  patch '/fests' => 'fests#create'
  post '/fests/:id' => 'fests#update'
  patch '/fests/:id' => 'fests#update'
  post '/fests/:id/totalize' => 'fests#totalize'
  
end
