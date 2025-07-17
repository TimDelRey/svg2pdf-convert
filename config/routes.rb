Rails.application.routes.draw do
  root to: 'conversion_records#new'
  
  resources :conversion_records, only: [:new, :create, :show] do
    member do
      get :download
    end
  end
end
