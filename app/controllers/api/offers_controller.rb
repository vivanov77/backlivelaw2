class Api::OffersController < Api::ApplicationController

  # before_action :authenticate_user!
  # load_and_authorize_resource
    
  before_action :set_offer, only: [:show, :update, :destroy]

  before_action :set_render_options, only: [:show, :index]

  # after_action :mail_notification, only: [:create]  

  # GET /offers
  def index

    @offers = Offer.order(:id)

    render( {json: @offers}.merge set_render_options )

  end

  # GET /offers/1
  def show

    render( {json: @offer}.merge set_render_options )    

  end

  # POST /offers
  def create
    @offer = Offer.new(offer_params)

    if @offer.save
      render json: @offer, status: :created, location: [:api, @offer]
    else
      render json: @offer.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /offers/1
  def update
    if @offer.update(offer_params)
      render json: @offer
    else
      render json: @offer.errors, status: :unprocessable_entity
    end
  end

  # DELETE /offers/1
  def destroy
    @offer.destroy
    render json: "Счёт с id=\"#{@offer.id}\" успешно удалён".to_json, status: :ok    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_offer
      @offer = Offer.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def offer_params
      # params.require(:offer).permit(:title, :user_ids)

# https://www.simplify.ba/articles/2016/06/18/creating-rails5-api-only-application-following-jsonapi-specification/
# https://github.com/rails-api/active_model_serializers/blob/v0.10.6/docs/general/deserialization.md

      res = ActiveModelSerializers::Deserialization.jsonapi_parse(params)

      if user_signed_in?

        res[:sender_id] = current_user.id

      end

      res    

    end

    def set_render_options

      show_sender = (param? params[:sender])

      show_recipient = (param? params[:recipient])      

      show_virtual_relation_payment = (param? params[:payment])


      render_conditions = 

      {

        show_sender: show_sender,

        show_recipient: show_recipient,        
        
        show_virtual_relation_payment: show_virtual_relation_payment,    

        include: [:sender, :recipient, :virtual_relation_payment]
      }  

    end    

    # def mail_notification

    #   email = Rails.env.development? ? secret_key("FEEDBACKS_MAIL") : current_user.email

    #   OffersMailer.offer_created(@offer, email).deliver_now if current_user

    # end

end