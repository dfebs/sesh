Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :users, only: [ :create, :new ]
  resources :user_configs, only: [ :edit, :update ]
  root "workout_sessions#index"

  resources :workouts do
    collection do
      get "new_from_templates"
      post "create_from_templates"
    end
  end

  resources :workout_sessions do
    member do
      post "duplicate"
    end
    resources :workout_instances, shallow: true, only: %i[new create destroy] do
      resources :workout_sets, shallow: true, only: %i[ new destroy create edit update ]
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
