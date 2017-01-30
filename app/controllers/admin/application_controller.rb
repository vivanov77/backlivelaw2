class Admin::ApplicationController < ApplicationController
	protect_from_forgery with: :exception
end
