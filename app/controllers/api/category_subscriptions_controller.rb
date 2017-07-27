class Api::CategorySubscriptionsController < Api::ApplicationController
  before_action :set_category_subscription, only: [:show, :update, :destroy]

  # GET /category_subscriptions
  # GET /category_subscriptions.json
  def index

      @category_subscriptions = CategorySubscription.all

      render json: @category_subscriptions

  end

  # GET /category_subscriptions/1
  # GET /category_subscriptions/1.json
  def show
    render json: @category_subscription
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category_subscription
      @category_subscription = CategorySubscription.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    # def category_subscription_params
    #   params.require(:category_subscription).permit(:ip_block_start, :ip_block_end, :ip_range, :kladr_city_code, :city_id, :ip)
    # end
end
