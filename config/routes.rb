Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  root to: 'conversion_records#new'
  
  resources :conversion_records, only: [:new, :create, :show] do
    member do
      get :download
    end
  end
end
