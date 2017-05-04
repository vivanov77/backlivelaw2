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

		resources :doc_responses
		resources :doc_requests

		resources :lib_entries do
			resources :lib_entries do
				resources :lib_entries
			end
		end

		resources :messages

		resources :guest_chat_tokens		
	end

	namespace :api do

		resources :questions, only: [:index, :show, :create, :update] do
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

		mount_devise_token_auth_for 'User', at: 'auth', controllers: { sessions: 'api/users/sessions' }

		# devise_for :users, controllers: { sessions: 'api/users/sessions' }

	    resources :users, only: [:index, :show, :update] # after devise_for :users!!!!

	    resources :search, only: [:index]

		resources :doc_responses, only: [:index, :show, :create, :update]
		resources :doc_requests, only: [:index, :show, :create, :update]

		resources :doc_requests, only: [:index, :show, :create, :update] do
			resources :doc_responses
		end

		resources :lib_entries, except: [:destroy] do
			resources :lib_entries, except: [:destroy] do
				resources :lib_entries, except: [:destroy]
			end
		end

		resources :messages, only: [:index, :create, :update]

		resources :guest_chat_tokens, only: [:create, :show]

		resources :secret_chat_tokens, only: [:create, :show]

		resources :chat_messages, only: [:index]		

	end	

	# Serve websocket cable requests in-process
	mount ActionCable.server => '/cable'

end
