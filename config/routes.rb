require 'sidekiq/web'

Admin::Application.routes.draw do
  root to: 'home#index'
  authenticate :admin_user do
    mount Sidekiq::Web => '/admin/sidekiq'
  end
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end
