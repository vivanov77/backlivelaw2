class Admin::CashOperationsController < Admin::ApplicationController
  before_action :set_cash_operation, only: [:show, :edit, :update, :destroy]

  # GET /cash_operations
  # GET /cash_operations.json
  def index
    @cash_operations = CashOperation.all
  end

  # GET /cash_operations/1
  # GET /cash_operations/1.json
  def show
  end

  # GET /cash_operations/new
  def new
    @cash_operation = CashOperation.new
  end

  # GET /cash_operations/1/edit
  def edit
  end

  # POST /cash_operations
  # POST /cash_operations.json
  def create
    @cash_operation = CashOperation.new(cash_operation_params)

    respond_to do |format|
      if @cash_operation.save

        format.html { redirect_to [:admin, @cash_operation], notice: 'Операция с наличными была успешно создана.' }
        format.json { render :show, status: :created, location: @cash_operation }
      else
        format.html { render :new }
        format.json { render json: @cash_operation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cash_operations/1
  # PATCH/PUT /cash_operations/1.json
  def update
    respond_to do |format|
      if @cash_operation.update(cash_operation_params)
        format.html { redirect_to [:admin, @cash_operation], notice: 'Операция с наличными была успешно обновлена.' }
        format.json { render :show, status: :ok, location: @cash_operation }
      else
        format.html { render :edit }
        format.json { render json: @cash_operation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cash_operations/1
  # DELETE /cash_operations/1.json
  def destroy
    @cash_operation.destroy
    respond_to do |format|
      format.html { redirect_to admin_cash_operations_url, notice: 'Операция с наличными была успешно удалена.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cash_operation
      @cash_operation = CashOperation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cash_operation_params
      params.require(:cash_operation).permit(:user_id, :comment, :operation, :sum)
    end
end