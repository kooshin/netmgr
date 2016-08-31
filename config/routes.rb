Rails.application.routes.draw do
  resources :hosts, shallow: true do
    resources :ports
  end

  get 'ports', to: 'ports#index'

  mount Sidekiq::Web => '/sidekiq'

  root to: 'hosts#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
