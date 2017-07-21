class Api::LibEntriesController < Api::ApplicationController

  # before_action :authenticate_user!
  # load_and_authorize_resource
    
  before_action :set_lib_entry, only: [:show, :update, :destroy]

  before_action :check_removed_attachment, only: [:update]    

  # GET /lib_entries
  # GET /lib_entries.json
  def index

    if params[:lib_entry_id]
      @lib_entries = LibEntry.where(id: params[:lib_entry_id])
      render json: @lib_entries, include: [:lib_entries], show_lib_entries: true
    else
      @lib_entries = LibEntry.order(:title)
      render json: @lib_entries
    end

  end

  # GET /lib_entries/1
  # GET /lib_entries/1.json
  def show
    render json: @lib_entry
  end

  # POST /lib_entries
  # POST /lib_entries.json
  def create
    @lib_entry = LibEntry.new(lib_entry_params)

    if @lib_entry.save
      render json: @lib_entry, status: :created, location: [:api, @lib_entry]
    else
      render json: @lib_entry.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /lib_entries/1
  # PATCH/PUT /lib_entries/1.json
  def update
    if @lib_entry.update(lib_entry_params)
      render json: @lib_entry
    else
      render json: @lib_entry.errors, status: :unprocessable_entity
    end
  end

  # DELETE /lib_entries/1
  # DELETE /lib_entries/1.json
  # def destroy
  #   @lib_entry.destroy
  #   render json: "Комментарий с id=\"#{@lib_entry.id}\" успешно удалён".to_json, status: :ok    
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lib_entry
      @lib_entry = LibEntry.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lib_entry_params
      # params.require(:lib_entry).permit(:title)
# https://www.simplify.ba/articles/2016/06/18/creating-rails5-api-only-application-following-jsonapi-specification/
# https://github.com/rails-api/active_model_serializers/blob/v0.10.6/docs/general/deserialization.md

      if params[:data] # JSON queries - default

        res = ActiveModelSerializers::Deserialization.jsonapi_parse(params)

      else # multipart form data - file upload
        
        # res = params.require(:user).permit(:title, :text, :user_id, :category_ids, 
        #   file_containers_attributes: ["file", "@original_filename", "@content_type", "@headers", "_destroy", "id"])

        res = params.require(:lib_entry).permit(:title, :text, :file, :data, :destroy_attachment)

      end

      res

    end

    def check_removed_attachment

      if params[:destroy_attachment]

        @lib_entry.remove_file!

        @lib_entry.save!

        remove_file_directory @lib_entry.file    
        
      end

    end

end
