require 'resque/server'

Photos::Application.routes.draw do

  resque_constraint = lambda do |req|
    req.env['warden'].authenticate?
  end
  constraints resque_constraint do
    mount Resque::Server, :at => '/resque', :as => 'resque'
  end

  devise_for :admins
  resources :admins, :only => [:edit, :update]
  resources :galleries, :only => [:index, :new, :create]
  get 'galleries/:secret', :to => "galleries#show"

  get 'about-us', :to => "public#about_us", :as => :about
  root 'public#index'
end
