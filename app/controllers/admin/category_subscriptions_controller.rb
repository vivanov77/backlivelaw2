class Admin::CategorySubscriptionsController < Admin::ApplicationController
  before_action :set_category_subscription, only: [:show, :edit, :update, :destroy]

  # GET /category_subscriptions
  # GET /category_subscriptions.json
  def index
    @category_subscriptions = CategorySubscription.all
  end

  # GET /category_subscriptions/1
  # GET /category_subscriptions/1.json
  def show
  end

  # GET /category_subscriptions/new
  def new
    @category_subscription = CategorySubscription.new
  end

  # GET /category_subscriptions/1/edit
  def edit
  end

  # POST /category_subscriptions
  # POST /category_subscriptions.json
  def create
    @category_subscription = CategorySubscription.new(category_subscription_params)

    respond_to do |format|
      if @category_subscription.save
        format.html { redirect_to [:admin, @category_subscription], notice: 'Подписка на категорию была успешно создана.' }
        format.json { render :show, status: :created, location: @category_subscription }
      else
        format.html { render :new }
        format.json { render json: @category_subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /category_subscriptions/1
  # PATCH/PUT /category_subscriptions/1.json
  def update
    respond_to do |format|
      if @category_subscription.update(category_subscription_params)
        format.html { redirect_to [:admin, @category_subscription], notice: 'Подписка на категорию был успешно обновлена.' }
        format.json { render :show, status: :ok, location: @category_subscription }
      else
        format.html { render :edit }
        format.json { render json: @category_subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /category_subscriptions/1
  # DELETE /category_subscriptions/1.json
  def destroy
    @category_subscription.destroy
    respond_to do |format|
      format.html { redirect_to admin_category_subscriptions_url, notice: 'Подписка на категорию была успешно удалена.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category_subscription
      @category_subscription = CategorySubscription.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_subscription_params
      # params.require(:category_subscription).permit(:chosen, :text, :price, :user_id, :doc_request_id,
      #   file_containers_attributes: ["file", "@original_filename", "@content_type", "@headers", "_destroy", "id"])
      params.require(:category_subscription).permit!
    end
end
