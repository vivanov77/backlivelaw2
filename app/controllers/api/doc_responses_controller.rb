class Api::DocResponsesController < Api::ApplicationController

  # before_action :authenticate_user!
  # load_and_authorize_resource
    
  before_action :set_doc_response, only: [:show, :update, :destroy]

  before_action :set_render_options, only: [:show, :index]

  before_action :set_check_date, only: [:show]

  before_action :set_complaint_date, only: [:update]

  # GET /doc_responses
  def index

    @doc_responses = DocResponse.all

    if params[:category]

# http://guides.rubyonrails.org/active_record_querying.html#nested-associations-hash

      @doc_responses = @doc_responses.includes(doc_response_request: [:categories]).where(categories: {name: params[:category]})

    end

      render( {json: @doc_responses}.merge set_render_options )
  end

  # GET /doc_responses/1
  def show

    render( {json: @doc_response}.merge set_render_options )

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
# https://github.com/rails-api/active_model_serializers/blob/v0.10.6/docs/general/deserialization.md

      if params[:data] # JSON queries - default

        res = ActiveModelSerializers::Deserialization.jsonapi_parse(params, except: [:check_date])

      else # multipart form data - file upload
        
        res = params.require(:doc_response).permit(:chosen, :text, :price, :user_id, :doc_response_request_id, 
          file_containers_attributes: ["file", "@original_filename", "@content_type", "@headers", "_destroy", "id"])
      end

      # if user_signed_in?

      #   res[:user_id] = current_user.id

      # end

      res      

    end

    def set_render_options

      show_user = (param? params[:user])      

      show_categories = (param? params[:categories])

      show_doc_request = (param? params[:doc_request])      


      render_conditions = 

      {

        show_user: show_user,

        show_categories: show_categories,

        show_doc_request: show_doc_request,        

        # include: [:user, :categories, "doc_request.**"]
        include: [:user, :categories, :doc_request]        
      }  

    end

    def set_check_date

      if current_user.try(:has_role?, :client)

        if @doc_response.doc_request.user == current_user

          unless @doc_response.check_date

            @doc_response.check_date = Time.now

            @doc_response.save!

          end

        end

      end

    end

    def set_complaint_date

      if doc_response_params[:complaint_date]

        raise UserError, "Вы не можете пожаловаться на выполненный заказ на документ не ознакомившись (не открыв его хотя бы раз) с ним предварительно." unless @doc_response.check_date

        complaint_date = ActiveSupport::TimeZone['UTC'].parse doc_response_params[:complaint_date]

        check_timeout = @doc_response.check_date - @doc_response.created_at

        # raise UserError, "У выполненного заказа на документ дата ознакомления должна быть позже даты создания." if (check_timeout < 0)

        raise UserError, "Вы не можете пожаловаться на выполненный заказ на документ позднее 3-х дней с момента его создания." if (check_timeout > 3.days)

        complaint_timeout = complaint_date - @doc_response.check_date

        raise UserError, "Вы не можете пожаловаться на выполненный заказ на документ позднее 1-х суток после ознакомления с ним." if (complaint_timeout > 1.day)

        @doc_response.complaint_date = complaint_date

        @doc_response.save!

      end

    end
end