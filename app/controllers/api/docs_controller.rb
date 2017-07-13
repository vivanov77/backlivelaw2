class Api::DocsController < Api::ApplicationController

  # before_action :authenticate_user!
  # load_and_authorize_resource
    
  before_action :set_doc, only: [:show, :update, :destroy]

  # GET /docs
  def index

    @docs = Doc

    show_categories = (param? params[:categories])

    show_user = (param? params[:user])

    if params[:category]

# http://guides.rubyonrails.org/active_record_querying.html#nested-associations-hash

      @docs = @docs.includes(doc_request: [:categories]).where(categories: {name: params[:category]})

    end

    @docs = @docs.order(:id)

    render json: @docs,

    show_user: show_user,

    show_doc_request: show_categories,

    show_categories: show_categories,

    include: [:user, "doc_request.**"]

  end

  # GET /docs/1
  def show

    show_categories = (param? params[:categories])

    show_user = (param? params[:user])
    

    render json: @doc,

    show_user: show_user,

    show_doc_request: show_categories,

    show_categories: show_categories,

    include: [:user, "doc_request.**"]

  end

  # POST /docs
  def create
    @doc = Doc.new(doc_params)

    if @doc.save
      render json: @doc, status: :created, location: [:api, @doc]
    else
      render json: @doc.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /docs/1
  def update
    if @doc.update(doc_params)
      render json: @doc
    else
      render json: @doc.errors, status: :unprocessable_entity
    end
  end

  # DELETE /docs/1
  # def destroy
  #   @doc.destroy
  #   render json: "Вопрос с id=\"#{@doc.id}\" успешно удалён".to_json, status: :ok    
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doc
      @doc = Doc.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def doc_params
      # params.require(:doc).permit(:title, :user_ids)

# https://www.simplify.ba/articles/2016/06/18/creating-rails5-api-only-application-following-jsonapi-specification/
# https://github.com/rails-api/active_model_serializers/blob/master/docs/general/deserialization.md

      if params[:data] # JSON queries - default

        res = ActiveModelSerializers::Deserialization.jsonapi_parse(params)

      else # multipart form data - file upload
        
        res = params.require(:doc).permit(:chosen, :text, :price, :user_id, :doc_request_id, 
          file_containers_attributes: ["file", "@original_filename", "@content_type", "@headers", "_destroy", "id"])
      end

      if user_signed_in?

        res[:user_id] = current_user.id

      end

      res      

    end 
end