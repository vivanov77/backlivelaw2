class Api::ChatSessionsController < Api::ApplicationController

  # before_action :authenticate_user!
  # load_and_authorize_resource
    
  before_action :set_chat_session, only: [:show, :update, :destroy]

  before_action :set_render_options, only: [:show, :index]

  # after_action :mail_notification, only: [:create]  

  # GET /chat_sessions
  def index

    @chat_sessions = ChatSession.order(:id)

    render( {json: @chat_sessions}.merge set_render_options )

  end

  # GET /chat_sessions/1
  def show

    render( {json: @chat_session}.merge set_render_options )    

  end

  # POST /chat_sessions
  def create
    @chat_session = ChatSession.new(chat_session_params)

    if @chat_session.save
      render json: @chat_session, status: :created, location: [:api, @chat_session]
    else
      render json: @chat_session.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /chat_sessions/1
  def update
    if @chat_session.update(chat_session_params)
      render json: @chat_session
    else
      render json: @chat_session.errors, status: :unprocessable_entity
    end
  end

  # DELETE /chat_sessions/1
  def destroy
    @chat_session.destroy
    render json: "Счёт с id=\"#{@chat_session.id}\" успешно удалён".to_json, status: :ok    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat_session
      @chat_session = ChatSession.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def chat_session_params
      # params.require(:chat_session).permit(:title, :user_ids)

# https://www.simplify.ba/articles/2016/06/18/creating-rails5-api-only-application-following-jsonapi-specification/
# https://github.com/rails-api/active_model_serializers/blob/v0.10.6/docs/general/deserialization.md

      res = ActiveModelSerializers::Deserialization.jsonapi_parse(params)

      if user_signed_in?

        res[:sender_id] = current_user.id

      end

      res    

    end

    def set_render_options

      # show_sender = (param? params[:sender])

      # show_recipient = (param? params[:recipient])      

      # show_virtual_relation_payment = (param? params[:payment])


      # render_conditions = 

      # {

      #   show_sender: show_sender,

      #   show_recipient: show_recipient,        
        
      #   show_virtual_relation_payment: show_virtual_relation_payment,    

      #   include: [:sender, :recipient, :virtual_relation_payment]
      # }  

      {}

    end    

    # def mail_notification

    #   email = Rails.env.development? ? secret_key("FEEDBACKS_MAIL") : current_user.email

    #   ChatSessionsMailer.chat_session_created(@chat_session, email).deliver_now if current_user

    # end

end