Rails.application.routes.draw do
  resources :categories
  resources :clients
#  resources :messages
#  get 'log/index'
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



get "/active", to: "active#index"


get "/accounts", to: "accounts#index"
  get "/accounts/new", to: "accounts#new", as: :new_account
  post "/accounts", to: "accounts#create", as: :create_account

  get "/accounts/:id/edit", to: "accounts#edit", as: :edit_account
  put "/accounts/:id/update", to: "accounts#update", as: :update_account

  post "/accounts/:id/enter", to: "accounts#enter", as: :enter_account

  post "/superuser/:id/enter", to: "accounts#entersuperuser", as: :enter_superuser


delete "/accounts/:id", to: "accounts#destroy", as: :del_account

get "/phone", to: "phone#show"

get "/phone/getinfo/:callerid", to: "phone#getinfo"
get "/phone/getnotes/:callerid", to: "phone#getnotes"

get "/phone/updateinfo/:clientid", to: "phone#updateinfo"
get "/phone/addnote/:clientid", to: "phone#addnote"
get "/phone/addcallnote", to: "phone#addcallnote"
get "/phone/getstat", to: "phone#getstat"

get "/phone/setlang/:lang", to: "phone#show", as: :phone_setlang


get "/cdr", to: "cdr#index"
post "/cdr", to: "cdr#search", as: :search_cdr

get "/stats", to: "queuelog#index"
post "/stats", to: "queuelog#search", as: :search_stats
get "/stats/ajaxtest", to: "queuelog#ajaxtest", as: :ajaxtest
get "/stats/calls/:pageid/:queueid/:extenid/:datestart/:dateend", to: "queuelog#showcalls", as: :stats_showcalls


get "/monitor", to: "monitor#index"
post "/livemonitor", to: "monitor#search", as: :search_monitor
get "/livemonitor", to: "monitor#livemonitor", as: :livemonitor



get "/gettoken", to: "accounts#gettoken"

get "/logs", to: "log#index"
post "/logs", to: "log#search", as: :search_logs

get "/messages", to: "messages#index"
post "/messages", to: "messages#search", as: :search_messages

get "/myaccount", to: "accounts#show", as: :myaccount
post "/myaccount", to: "accounts#updatemyaccount", as: :update_myaccount

root to: "messages#index"

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


#CRUD Ringgroup
  get "/steps/ringgroup/new", to: "steps#newringgroup", as: :new_stepringgroup
  post "/steps/ringgroup", to: "steps#createringgroup", as: :add_stepringgroup
  get "/steps/:id/ringgroup/edit", to: "steps#editringgroup", as: :edit_stepringgroup
  put "/steps/:id/ringgroup", to: "steps#updateringgroup", as: :update_stepringgroup

#CRUD Voicemail
  get "/steps/voicemail/new", to: "steps#newvoicemail", as: :new_stepvoicemail
  post "/steps/voicemail", to: "steps#createvoicemail", as: :add_stepvoicemail
  get "/steps/:id/voicemail/edit", to: "steps#editvoicemail", as: :edit_stepvoicemail
  put "/steps/:id/voicemail", to: "steps#updatevoicemail", as: :update_stepvoicemail



  resources :steps
  post "/steps/:id/stepup", to: "steps#stepup", as: :stepup
  post "/steps/:id/stepdown", to: "steps#stepdown", as: :stepdown

end


scope '/mohs/:mohid/' do
#CRUD MOH Entries
resources :mohentries
end

scope '/clients/:clientid/' do
  resources :notes

end











scope '/sips/:sipid/' do
get "/siproutes", to: "routes#siproutes", as: :siproutes
end



#API
namespace :api do
scope 'v1/' do
get "/clients", to: "clients#index", as: :clients
delete "/clients/:id", to: "clients#destroy", as: :clientdel
put "/clients/:id", to: "clients#update", as: :updateclient
post "/clients", to: "clients#create", as: :createclient

get "/clients/:clientid/notes", to: "clientnotes#index", as: :clientnotes
delete "/clients/:clientid/notes/:id", to: "clientnotes#destroy", as: :clientnotedel
put "/clients/:clientid/notes/:id", to: "clientnotes#update", as: :updateclientnote
post "/clients/:clientid/notes", to: "clientnotes#create", as: :createclientnote

post "/cdrs", to: "cdrs#index", as: :cdrs
post "/queuelogs", to: "queuelogs#index", as: :queuelogs

post "/comments", to: "comments#index", as: :comments
post "/comment", to: "comments#show", as: :comment
delete "/comments/:id", to: "comments#destroy", as: :commentsdel
post "/comments/create", to: "comments#create", as: :createcomment
put "/comments/:id", to: "comments#update", as: :updatecomment


get "/categories", to: "categories#index", as: :categories
post "/categories", to: "categories#create", as: :createcategory
put "/categories/:id", to: "categories#update", as: :updatecategory
delete "/categories/:id", to: "categories#destroy", as: :categorydel


get "/queues", to: "queues#index", as: :queues
get "/queues/:queueid/agents", to: "queueagents#index", as: :queueagents
post "/queues/:queueid/agents", to: "queueagents#create", as: :createqueueagents
delete "/queues/:queueid/agents/:id", to: "queueagents#destroy", as: :queueagentdel

end
end

#End of API


end
