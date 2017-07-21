class Api::FileContainersController < Api::ApplicationController
    
  before_action :set_file_container, only: [:show, :update, :destroy]
    
  # GET /file_containers
  def index
    @file_containers = FileContainer.all

    render json: @file_containers
  end

  # GET /file_containers/1
  def show
    render json: @file_container
  end

  # POST /file_containers
  # POST /file_containers.json
  def create

    @file_container = FileContainer.new(file_container_params)

    @file_container.file = params[:file]

    @file_container.fileable_type = "Question"

    @file_container.fileable_id = params[:id]

    if @file_container.save
      render json: @file_container, status: :created, location: [:api, @file_container]
    else
      render json: @file_container.errors, status: :unprocessable_entity
    end
  end

  # # PATCH/PUT /file_containers/1
  # def update
  #   if @file_container.update(file_container_params)
  #     render json: @file_container
  #   else
  #     render json: @file_container.errors, status: :unprocessable_entity
  #   end
  # end

  # DELETE /file_containers/1
  def destroy
    @file_container.destroy
    render json: "FileContainer with id=\"#{@file_container.id}\" deleted successfully".to_json, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_file_container
      @file_container = FileContainer.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def file_container_params
      # params.require(:file_container).permit(:first_name)
# https://www.simplify.ba/articles/2016/06/18/creating-rails5-api-only-application-following-jsonapi-specification/
# https://github.com/rails-api/active_model_serializers/blob/v0.10.6/docs/general/deserialization.md
      ActiveModelSerializers::Deserialization.jsonapi_parse(params)      
    end 
end