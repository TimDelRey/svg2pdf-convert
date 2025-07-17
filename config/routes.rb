Rails.application.routes.draw do
  root to: 'conversion_records#new'
  
  resource :conversion_records, only: [:new, :create] do
    get :export, on: :member
  end
end
