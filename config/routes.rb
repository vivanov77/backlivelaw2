Rails.application.routes.draw do


  devise_for :users
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

	    resources :categories

	    resources :users, only: [:index, :show, :edit, :update, :destroy] # after devise_for :users!!!!	

	end

	namespace :api do

		resources :questions

		resources :comments

	    resources :categories  

		# resources :questions do
		#   get 'page/:page', action: :index, on: :collection
		# end

	    # resources :users, only: [:index, :show, :edit, :update, :destroy] # after devise_for :users!!!!
	    resources :users, only: [:index, :show, :edit, :update] # after devise_for :users!!!!

	    resources :search, only: [:index]

	end	

end
