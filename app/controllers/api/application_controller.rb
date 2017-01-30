class Api::ApplicationController < ActionController::API
	
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_record

  private

    def invalid_record error
    	
      render json: { errors: error }, status: 404
    end

end