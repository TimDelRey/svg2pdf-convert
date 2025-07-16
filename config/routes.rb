Rails.application.routes.draw do
  root to: 'conversion_records#new'
  
  resources :conversion_records, only: :new do
    get :export, on: :member
  end
end
