class Api::FeedbacksController < Api::ApplicationController

  # before_action :authenticate_user!
  # load_and_authorize_resource
    
  before_action :set_feedback, only: [:show, :update, :destroy]

  after_action :mail_notification, only: [:create]

  # GET /feedbacks
  def index

    @feedbacks = Feedback.order(:id);

    show_user = (param? params[:user])

    render json: @feedbacks,

    show_user: (param? params[:user]),

    include: :user

  end

  # GET /feedbacks/1
  def show

    show_user = (param? params[:user])    

    render json: @feedback,

    show_user: (param? params[:user]),

    include: :user    

  end

  # POST /feedbacks
  def create
    @feedback = Feedback.new(feedback_params)

    if @feedback.save
      render json: @feedback, status: :created, location: [:api, @feedback]
    else
      render json: @feedback.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /feedbacks/1
  # def update
  #   if @feedback.update(feedback_params)
  #     render json: @feedback
  #   else
  #     render json: @feedback.errors, status: :unprocessable_entity
  #   end
  # end

  # DELETE /feedbacks/1
  # def destroy
  #   @feedback.destroy
  #   render json: "Вопрос с id=\"#{@feedback.id}\" успешно удалён".to_json, status: :ok    
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feedback
      @feedback = Feedback.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def feedback_params
      # params.require(:feedback).permit(:title, :user_ids)

# https://www.simplify.ba/articles/2016/06/18/creating-rails5-api-only-application-following-jsonapi-specification/
# https://github.com/rails-api/active_model_serializers/blob/v0.10.6/docs/general/deserialization.md

      res = ActiveModelSerializers::Deserialization.jsonapi_parse(params)

      if user_signed_in?

        res[:user_id] = current_user.id

      end

      res    

    end 

    def mail_notification

      if @emails = (Configurable.found_csubtypes :feedback_notify_email, :email)

        @emails.each do |email|
          
          # FeedbacksMailer.feedback_notification(@feedback, email).deliver_later
          FeedbacksMailer.feedback_notification(@feedback, email).deliver_now
          
        end

      else

        # FeedbacksMailer.feedback_notification(@feedback, secret_key("FEEDBACKS_MAIL")).deliver_later
        FeedbacksMailer.feedback_notification(@feedback, secret_key("FEEDBACKS_MAIL")).deliver_now

      end

    end
end