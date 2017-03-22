class Api::DocRequestsController < Api::ApplicationController

  # before_action :authenticate_user!
  # load_and_authorize_resource
    
  before_action :set_doc_request, only: [:show, :update, :destroy]

  # GET /doc_requests
  def index

    @doc_requests = DocRequest.order(:id);

    render json: @doc_requests

  end

  # GET /doc_requests/1
  def show

    render json: @doc_request

  end

  # POST /doc_requests
  def create
    @doc_request = DocRequest.new(doc_request_params)

    if @doc_request.save
      render json: @doc_request, status: :created, location: [:api, @doc_request]
    else
      render json: @doc_request.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /doc_requests/1
  def update
    if @doc_request.update(doc_request_params)
      render json: @doc_request
    else
      render json: @doc_request.errors, status: :unprocessable_entity
    end
  end

  # DELETE /doc_requests/1
  # def destroy
  #   @doc_request.destroy
  #   render json: "Вопрос с id=\"#{@doc_request.id}\" успешно удалён".to_json, status: :ok    
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doc_request
      @doc_request = DocRequest.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def doc_request_params
      # params.require(:doc_request).permit(:title, :user_ids)

# https://www.simplify.ba/articles/2016/06/18/creating-rails5-api-only-application-following-jsonapi-specification/
# https://github.com/rails-api/active_model_serializers/blob/master/docs/general/deserialization.md

      res = ActiveModelSerializers::Deserialization.jsonapi_parse(params)

      if user_signed_in?

        res[:user_id] = current_user.id

      end

      res    

    end 
end