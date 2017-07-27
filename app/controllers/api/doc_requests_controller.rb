class Api::DocRequestsController < Api::ApplicationController

  # before_action :authenticate_user!
  # load_and_authorize_resource
    
  before_action :set_doc_request, only: [:show, :update, :destroy]

  before_action :set_render_options, only: [:show, :index]

  after_action :mail_notification, only: [:create]

  # GET /doc_requests
  def index

    @doc_requests = DocRequest

    raise UserError, "No user logged in" unless current_user

    if current_user.has_role? :client

      @doc_requests = @doc_requests.where(user_id: current_user.id)

    elsif (current_user.has_role?(:lawyer) || current_user.has_role?(:jurist))

       @doc_requests = @doc_requests.includes(:categories).

       where(categories: {id: (current_user.actual_purchased_categories.map &:id)})

    end

    if param? params[:unpaid]

      @doc_requests = @doc_requests.unpaid

    end

    if param? params[:paid]

      @doc_requests = @doc_requests.paid

    end

    # if param? params[:unpaid_categorized] && user_signed_in?

    #   @doc_requests = @doc_requests.unpaid_categorized current_user.actual_purchased_categories

    # end

    @doc_requests = @doc_requests.order(:id)

    render( {json: @doc_requests}.merge set_render_options )

  end

  # GET /doc_requests/1
  def show

    render( {json: @doc_request}.merge set_render_options )

  end

  # POST /doc_requests
  def create
    @doc_request = DocRequest.new(doc_request_params)

    register_user    

    if @doc_request.save
      render( {json: @doc_request, status: :created, location: [:api, @doc_request]}.merge set_render_options)
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
# https://www.simplify.ba/articles/2016/06/18/creating-rails5-api-only-application-following-jsonapi-specification/
# https://github.com/rails-api/active_model_serializers/blob/v0.10.6/docs/general/deserialization.md

      if params[:data] # JSON queries - default

        res = ActiveModelSerializers::Deserialization.jsonapi_parse(params)

      else # multipart form data - file upload

        res = params.require(:doc_request).permit(:title, :text, :user_id, :category_ids, 
        file_containers_attributes: ["file", "@original_filename", "@content_type", "@headers", "_destroy", "id"])

      end

      if user_signed_in?

        res[:user_id] = current_user.id

      end

      res    

    end

    def set_render_options

      show_user = (param? params[:user]) || params[:email]

      show_proposals = (param? params[:proposals])

      show_categories = (param? params[:categories])

      show_virtual_relation_payment = (param? params[:payment])

      render_conditions = 

      {
        include: [:user, :categories, :proposals, :virtual_relation_payment],

        show_user: show_user,

        show_categories: show_categories,

        show_proposals: show_proposals,
        
        show_virtual_relation_payment: show_virtual_relation_payment
      }

    end

    def mail_notification

      if current_user

        email = current_user.email

        token = nil

      elsif @email

        email = @email

        token = @user.confirmation_token

      end

        DocRequestsMailer.doc_request_created(@doc_request, email, @password, token).deliver_now

    end    

    def register_user

      if !current_user && params[:email]

        @email = params[:email]

        @password = User.random_password   

        register_login_tokenized_user @email, @password

        @doc_request.user_id = @user.id

      end

    end    

end