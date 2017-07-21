class Api::CashOperationsController < Api::ApplicationController

  # before_action :authenticate_user!
  # load_and_authorize_resource
    
  before_action :set_cash_operation, only: [:show]

  before_action :set_render_options, only: [:show, :index]  

  # GET /cash_operations
  def index

    @cash_operations = CashOperation.order(:id);

    render( {json: @cash_operations}.merge set_render_options )

  end

  # GET /cash_operations/1
  def show

    render( {json: @cash_operation}.merge set_render_options )  

  end

  # POST /cash_operations
  def create
    @cash_operation = CashOperation.new(cash_operation_params)

    if @cash_operation.save
      render json: @cash_operation, status: :created, location: [:api, @cash_operation]
    else
      render json: @cash_operation.errors, status: :unprocessable_entity
    end  
  end

  # PATCH/PUT /cash_operations/1
  # def update
  #   if @cash_operation.update(cash_operation_params)
  #     render json: @cash_operation
  #   else
  #     render json: @cash_operation.errors, status: :unprocessable_entity
  #   end
  # end

  # DELETE /cash_operations/1
  # def destroy
  #   @cash_operation.destroy
  #   render json: "Вопрос с id=\"#{@cash_operation.id}\" успешно удалён".to_json, status: :ok    
  # end
# begin
#       rescue
#         error_message= "Вы можете создавать операцию с наличными только от своего имени."
#     render json: { errors: error_message }, status: :unprocessable_entity  
#     end  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cash_operation
      @cash_operation = CashOperation.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def cash_operation_params
      # params.require(:cash_operation).permit(:title, :user_ids)

# https://www.simplify.ba/articles/2016/06/18/creating-rails5-api-only-application-following-jsonapi-specification/
# https://github.com/rails-api/active_model_serializers/blob/v0.10.6/docs/general/deserialization.md

      res = ActiveModelSerializers::Deserialization.jsonapi_parse(params)

      if user_signed_in?

        if res[:user_id] && (current_user.id.to_s != res[:user_id].to_s)

          raise UserError, "Вы можете создавать операцию с наличными только от своего имени."

        else

          res[:user_id] = current_user.id

        end

      end

      res
      
    end

    def set_render_options

      show_user = (param? params[:user]) 

      render_conditions = 

      {
        include: [:user],

        show_user: show_user
      }

    end
end