class Api::DocResponsesController < Api::ApplicationController

  # before_action :authenticate_user!
  # load_and_authorize_resource
    
  before_action :set_doc_response, only: [:show, :update, :destroy]

  # GET /doc_responses
  def index

    @doc_responses = DocResponse.order(:id);

    render json: @doc_responses

  end

  # GET /doc_responses/1
  def show

    render json: @doc_response

  end

  # POST /doc_responses
  def create
    @doc_response = DocResponse.new(doc_response_params)

    if @doc_response.save
      render json: @doc_response, status: :created, location: [:api, @doc_response]
    else
      render json: @doc_response.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /doc_responses/1
  def update
    if @doc_response.update(doc_response_params)
      render json: @doc_response
    else
      render json: @doc_response.errors, status: :unprocessable_entity
    end
  end

  # DELETE /doc_responses/1
  # def destroy
  #   @doc_response.destroy
  #   render json: "Вопрос с id=\"#{@doc_response.id}\" успешно удалён".to_json, status: :ok    
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doc_response
      @doc_response = DocResponse.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def doc_response_params
      # params.require(:doc_response).permit(:title, :user_ids)

# https://www.simplify.ba/articles/2016/06/18/creating-rails5-api-only-application-following-jsonapi-specification/
# https://github.com/rails-api/active_model_serializers/blob/master/docs/general/deserialization.md

      if params[:data] # JSON queries - default

        res = ActiveModelSerializers::Deserialization.jsonapi_parse(params)

      else # multipart form data - file upload
        
        res = params.require(:doc_response).permit(:chosen, :text, :price, :user_id, :doc_request_id, 
          file_containers_attributes: ["file", "@original_filename", "@content_type", "@headers", "_destroy", "id"])
      end

      if user_signed_in?

        res[:user_id] = current_user.id

      end

      res      

    end 
end