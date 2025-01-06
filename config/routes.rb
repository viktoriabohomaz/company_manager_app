Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :companies do
        collection do
          post 'bulk_import', to: 'companies#bulk_import'
        end
      end
    end
  end
end
