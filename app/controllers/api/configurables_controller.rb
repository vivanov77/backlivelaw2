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

    check_value = (@configurable.respond_to? @configurable.name) ? (@configurable.send @configurable.name) : nil

    check_value_class = check_value.class.to_s.downcase.to_sym

    check_value_url = check_value.url ? Rails.root.to_s + "/public" + URI.unescape(check_value.url).to_s : nil

    hash_reply = {}

    hash_reply[:id] = @configurable.id

    hash_reply[:name] = @configurable.name

    hash_reply[:value] = check_value_class == :fileuploader ? check_value_url : @configurable.value

    hash_reply[:created_at] = @configurable.created_at

    hash_reply[:updated_at] = @configurable.updated_at

    render json: hash_reply

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
