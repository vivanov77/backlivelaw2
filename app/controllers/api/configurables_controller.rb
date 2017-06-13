class Api::ConfigurablesController < Api::ApplicationController
  # before_action :set_configurable, only: [:show]

  # GET /configurables
  # GET /configurables.json
  def index

    if params[:setting]

     @configurable = Configurable.found params[:setting]

     unless @configurable

      error_message = "Параметр настройки '#{params[:setting]}' не существует."

      render json: { errors: error_message }, status: :unprocessable_entity and return

     end

    render json: @configurable.to_json

    else

      error_message = "Отсутствует параметр setting."

      render json: { errors: error_message }, status: :unprocessable_entity 
    end

  end

  # GET /cities/1
  # GET /cities/1.json
  # def show
  #   render json: @configurable
  # end  

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_configurable
    #   @city = Configurable.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def configurable_params
      params.require(:configurable).permit!
    end
end
