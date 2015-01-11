Rails.application.routes.draw do
  resources :questionnaires, except: [:index, :destroy] do
    resources :questions, except: :show, shallow: true do
      member do
        patch :move
      end

      resources :answers, except: [:index, :show] do
        member do
          patch :move
          patch :toggle
        end
      end
    end

    resource :take, only: [:new, :create, :show]
    resource :entry, only: [:create, :show]
    resources :choices, only: [:create, :destroy]
  end

  root to: 'questionnaires#new'
end
