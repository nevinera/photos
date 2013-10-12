Photos::Application.routes.draw do

  devise_for :admins
  resources :admins, :only => [:edit, :update]
  resources :galleries, :only => [:index, :new, :create]
  get 'galleries/:secret', :to => "galleries#show"

  get 'about-us', :to => "public#about_us", :as => :about
  root 'public#index'
end
