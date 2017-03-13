Rails.application.routes.draw do

	devise_for :users, controllers: { sessions: 'users/sessions' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

	root 'admin/questions#index'

	namespace :admin do

		# resources :questions

		# resources :questions do
		#   get 'page/:page', action: :index, on: :collection
		# end
		resources :questions do
			resources :comments
		end

		resources :comments do
			resources :comments
		end

		resources :regions, only: [:index, :show] do
			resources :cities, only: [:index, :show]
		end

		resources :cities, only: [:index, :show]

		resources :ipranges, only: [:index, :show]	

	    resources :categories

	    resources :users, only: [:index, :show, :edit, :update, :destroy] # after devise_for :users!!!!	

	end

	namespace :api do

		# resources :questions

		# resources :comments
		resources :questions, only: [:index, :show, :create, :update]do
			resources :comments
		end

		resources :comments, only: [:index, :show, :create, :update] do
			resources :comments
		end

		resources :regions, only: [:index, :show] do
			resources :cities, only: [:index, :show]
		end

		resources :cities, only: [:index, :show]		

	    resources :categories, only: [:index, :show]

		mount_devise_token_auth_for 'User', at: 'auth'

		# , controllers: {
  #       registrations: 'api/registrations'
  #       }
		# , skip: [:omniauth_callbacks]

		# resources :questions do
		#   get 'page/:page', action: :index, on: :collection
		# end

	    # resources :users, only: [:index, :show, :edit, :update, :destroy] # after devise_for :users!!!!
	    resources :users, only: [:show, :update] # after devise_for :users!!!!

	    resources :search, only: [:index]

	end	

end
