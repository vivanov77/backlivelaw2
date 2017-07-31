Rails.application.routes.draw do

	# devise_for :users, controllers: { sessions: 'users/sessions' }
    devise_for :users, controllers: { sessions: 'users/sessions', :omniauth_callbacks => 'users/omniauth_callbacks' }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

	root 'admin/questions#index'

	# namespace :users do
	# 	get 'omniauth_callbacks/facebook'
	# 	get 'omniauth_callbacks/vkontakte'
	# 	# get 'omniauth_callbacks/odnoklassniki'
	# end

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

		resources :chat_messages

		resources :metro_lines, only: [:index]

	    resources :configurables, only: [:index, :show, :edit, :update, :destroy, :new]

	    resources :citations

	    resources :feedbacks

	    resources :chat_templates

	    resources :payments

	    resources :cash_operations

	    resources :payment_types, only: [:index, :show]

		resources :category_subscriptions

		resources :proposals do
			resources :comments
		end

		resources :offers

		resources :chat_sessions		
		  		
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

	    resources :users, only: [:index, :show, :update] # after devise_for :users!!!!

	    resources :search, only: [:index]

		resources :doc_responses, only: [:index, :show, :create, :update]
		resources :doc_requests, only: [:index, :show, :create, :update]

		resources :doc_requests, only: [:index, :show, :create, :update] do
			resources :docs
		end

		resources :lib_entries, except: [:destroy] do
			resources :lib_entries, except: [:destroy] do
				resources :lib_entries, except: [:destroy]
			end
		end

		resources :messages, only: [:index, :create, :update, :show]

		resources :guest_chat_tokens, only: [:create, :show]

		resources :secret_chat_tokens, only: [:create, :show]

		resources :chat_messages, only: [:index]

		resources :secret_message_tokens, only: [:create, :show]

	    resources :configurables, only: [:index]

	    resources :citations, only: [:index, :show]

	    resources :feedbacks, only: [:index, :create, :show]

	    resources :chat_templates, only: [:index, :show]

		resources :metro_lines, only: [:index, :show]

	    resources :payments, only: [:index, :create, :show]

	    resources :cash_operations, only: [:index, :create, :show]

		resources :category_subscriptions, only: [:index, :show]

		resources :proposals

		resources :offers

		resources :chat_sessions		

	end

	namespace :yandex_kassa do

		get 'pay' => 'kassa#pay'

		get 'check' => 'kassa#check'

		get 'aviso' => 'kassa#aviso'

	end

	# Serve websocket cable requests in-process
	mount ActionCable.server => '/cable'

		# namespace :users do
		# 	get 'omniauth_callbacks/facebook'
		# 	get 'omniauth_callbacks/vkontakte'
		# 	# get 'omniauth_callbacks/odnoklassniki'
		# end	

end
