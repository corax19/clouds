Rails.application.routes.draw do
  resources :mohs
#  resources :steps
  resources :routes
  resources :hotlines
  resources :extens
  resources :sips
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
get "/accounts", to: "accounts#index"

get "/cdr", to: "cdr#index"
post "/cdr", to: "cdr#search", as: :search_cdr

root to: "accounts#index"

get "/users", to: "permissions#index"
get "/users/new", to: "permissions#new"
post "/users/add", to: "permissions#create", as: :add_user
delete "/users/:id", to: "permissions#destroy", as: :del_user
get "/users/:id/edit", to: "permissions#edit", as: :edit_user
put "/users/:id/update", to: "permissions#update", as: :update_user



get "/sounds", to: "sounds#index"
get "/sounds/new", to: "sounds#new"
post "/sounds/add", to: "sounds#create", as: :add_sound
delete "/sounds/:id", to: "sounds#destroy", as: :del_sound



scope '/hotlines/:queueid/' do
  resources :agents
end

scope '/routes/:routeid/' do
#CRUD Playback Step
  get "/steps/playback/new", to: "steps#newplayback", as: :new_stepplayback
  post "/steps/playback", to: "steps#createplayback", as: :add_stepplayback
  get "/steps/:id/playback/edit", to: "steps#editplayback", as: :edit_stepplayback
  put "/steps/:id/playback", to: "steps#updateplayback", as: :update_stepplayback


#CRUD Dial Step
  get "/steps/dial/new", to: "steps#newdial", as: :new_stepdial
  post "/steps/dial", to: "steps#createdial", as: :add_stepdial
  get "/steps/:id/dial/edit", to: "steps#editdial", as: :edit_stepdial
  put "/steps/:id/dial", to: "steps#updatedial", as: :update_stepdial


#CRUD Dial Step External
  get "/steps/dialexternal/new", to: "steps#newdialexternal", as: :new_stepdialexternal
  post "/steps/dialexternal", to: "steps#createdialexternal", as: :add_stepdialexternal
  get "/steps/:id/dialexternal/edit", to: "steps#editdialexternal", as: :edit_stepdialexternal
  put "/steps/:id/dialexternal", to: "steps#updatedialexternal", as: :update_stepdialexternal



#CRUD Menu Step
  get "/steps/menu/new", to: "steps#newmenu", as: :new_stepmenu
  post "/steps/menu", to: "steps#createmenu", as: :add_stepmenu
  get "/steps/:id/menu/edit", to: "steps#editmenu", as: :edit_stepmenu
  put "/steps/:id/menu", to: "steps#updatemenu", as: :update_stepmenu



#CRUD Queue Step
  get "/steps/queue/new", to: "steps#newqueue", as: :new_stepqueue
  post "/steps/queue", to: "steps#createqueue", as: :add_stepqueue
  get "/steps/:id/queue/edit", to: "steps#editqueue", as: :edit_stepqueue
  put "/steps/:id/queue", to: "steps#updatequeue", as: :update_stepqueue




#CRUD Read Step
  get "/steps/read/new", to: "steps#newread", as: :new_stepread
  post "/steps/read", to: "steps#createread", as: :add_stepread
  get "/steps/:id/read/edit", to: "steps#editread", as: :edit_stepread
  put "/steps/:id/read", to: "steps#updateread", as: :update_stepread



  resources :steps
  post "/steps/:id/stepup", to: "steps#stepup", as: :stepup
  post "/steps/:id/stepdown", to: "steps#stepdown", as: :stepdown

end


scope '/mohs/:mohid/' do
#CRUD MOH Entries
resources :mohentries
end

end
