class Admin::PaymentsController < Admin::ApplicationController
  before_action :set_payment, only: [:show, :edit, :update, :destroy]

  after_action :process_payment_type, only: [:create, :update]

  # GET /payments
  # GET /payments.json
  def index
    @payments = Payment.all
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
  end

  # GET /payments/new
  def new
    @payment = Payment.new
  end

  # GET /payments/1/edit
  def edit
  end

  # POST /payments
  # POST /payments.json
  def create
    @payment = Payment.new(payment_params)

    respond_to do |format|
      if @payment.save
        format.html { redirect_to [:admin, @payment], notice: 'Платёж был успешно создан.' }
        format.json { render :show, status: :created, location: @payment }
      else
        format.html { render :new }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payments/1
  # PATCH/PUT /payments/1.json
  def update
    respond_to do |format|
      if @payment.update(payment_params)
        format.html { redirect_to [:admin, @payment], notice: 'Платёж был успешно обновлён.' }
        format.json { render :show, status: :ok, location: @payment }
      else
        format.html { render :edit }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to admin_payments_url, notice: 'Платёж был успешно удалён.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_params
      # params.require(:payment).permit(:sender_id, :recipient_id, :comment, :cfrozen, :operation, :sum, payable: [:ctype])
      params.require(:payment).permit!
    end

    def process_payment_type
      # "payment_type"=>"Category#1"

      payment_type = params[:payment_type]

      if payment_type 

        if payment_type.include? "#"

          ptype = payment_type.split "#"

          dest_class = class_by_name ptype.first

          found = dest_class.find ptype.second

          if found

            @payment.payment_type.destroy if @payment.payment_type

            @payment.create_payment_type(payable: found)

          end

        else

          @payment.payment_type.destroy if @payment.payment_type

        end
      end
    end

end