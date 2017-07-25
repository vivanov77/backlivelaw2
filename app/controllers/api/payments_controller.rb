class Api::PaymentsController < Api::ApplicationController

  # before_action :authenticate_user!
  # load_and_authorize_resource
    
  before_action :set_payment, only: :show

  before_action :set_render_options, only: [:show, :index]

  # before_action :set_frozen, only: [:create]

  # after_action :process_payment_type, only: [:create]

  after_action :mail_notification, only: [:create]  

  # GET /payments
  def index

    @payments = Payment.order(:id)

    render( {json: @payments}.merge set_render_options )

  end

  # GET /payments/1
  def show

    render( {json: @payment}.merge set_render_options )

  end

  # POST /payments
  def create
    @payment = Payment.new(payment_params)

    set_frozen

    if @payment.save

      process_payment_type

      render json: @payment, status: :created, location: [:api, @payment]
    else
      render json: @payment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /payments/1
  # def update
  #   if @payment.update(payment_params)
  #     render json: @payment
  #   else
  #     render json: @payment.errors, status: :unprocessable_entity
  #   end
  # end

  # DELETE /payments/1
  # def destroy
  #   @payment.destroy
  #   render json: "Вопрос с id=\"#{@payment.id}\" успешно удалён".to_json, status: :ok    
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def payment_params
      # params.require(:payment).permit(:title, :user_ids)

# https://www.simplify.ba/articles/2016/06/18/creating-rails5-api-only-application-following-jsonapi-specification/
# https://github.com/rails-api/active_model_serializers/blob/v0.10.6/docs/general/deserialization.md
      res = ActiveModelSerializers::Deserialization.jsonapi_parse(params, except: "payment-type" )

      if user_signed_in?

        if res[:sender_id] && (current_user.id.to_s != res[:sender_id].to_s)

          raise UserError, "Вы можете создавать платёж только от своего имени."

        else

          res[:sender_id] = current_user.id

        end

      end

      res
      
    end

   def process_payment_type

      payment_type = params.try(:[],"data").try(:[],"relationships").try(:[],"payment-type").try(:[],"data")

      if payment_type

        payable_type = payment_type.try(:[],"payable_type")

        payable_id = payment_type.try(:[],"payable_id")

        if payable_type && payable_id

          dest_class = class_by_name payable_type

          found = dest_class.find payable_id

          if found

            @payment.payment_type.destroy if @payment.payment_type

            @payment.create_payment_type(payable: found)

          end

        else

          @payment.payment_type.destroy if @payment.payment_type

        end
      end

    end

    def set_render_options

      show_sender = (param? params[:sender])

      show_recipient = (param? params[:recipient])

      show_payment_type = (param? params[:payment_type])      

      render_conditions = 

      {
        include: [:sender, :recipient, :payment_type],

        show_sender: show_sender,

        show_recipient: show_recipient,

        show_payment_type: show_payment_type,

      }

    end

    def set_frozen

      unless (@payment.sender.has_role? :admin) && (@payment.recipient.has_role? :admin)

        @payment.cfrozen = true

      end

    end

    def mail_notification

      email = Rails.env.development? ? secret_key("FEEDBACKS_MAIL") : @payment.recipient.email

      PaymentsMailer.payment_income(@payment, email).deliver_now if current_user

    end

end