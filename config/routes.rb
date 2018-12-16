Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: 'application#index'

  mount Sidekiq::Web, at: 'sidekiq'

  resources :subscriptions
end
