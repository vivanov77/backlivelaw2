Rails.application.routes.draw do

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

	root 'admin/questions#index'

	namespace :admin do

		resources :questions

		# resources :questions do
		#   get 'page/:page', action: :index, on: :collection
		# end

	    resources :users, only: [:index, :show, :edit, :update, :destroy] # after devise_for :users!!!!	

	end

	namespace :api do

		resources :questions
		
		# resources :questions do
		#   get 'page/:page', action: :index, on: :collection
		# end

	    resources :users, only: [:index, :show, :edit, :update, :destroy] # after devise_for :users!!!!	

	end	

end
