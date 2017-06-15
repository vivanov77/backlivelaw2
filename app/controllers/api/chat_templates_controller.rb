class Api::ChatTemplatesController < Api::ApplicationController
  before_action :set_chat_template, only: [:show]

  # GET /chat_templates
  # GET /chat_templates.json
  def index

    @chat_templates = ChatTemplate.where(user_id: current_user.id).all

    render json: @chat_templates

  end

  # GET /chat_templates/1
  # GET /chat_templates/1.json
  def show
    render json: @chat_template
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat_template
      @chat_template = ChatTemplate.where(user_id: current_user.id).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chat_template_params
      params.require(:chat_template).permit(:text, :user_id)
    end
end
