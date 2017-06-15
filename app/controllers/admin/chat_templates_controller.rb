class Admin::ChatTemplatesController < Admin::ApplicationController
  before_action :set_chat_template, only: [:show, :edit, :update, :destroy]

  # GET /chat_templates
  # GET /chat_templates.json
  def index
    @chat_templates = ChatTemplate.all
  end

  # GET /chat_templates/1
  # GET /chat_templates/1.json
  def show
  end

  # GET /chat_templates/new
  def new
    @chat_template = ChatTemplate.new
  end

  # GET /chat_templates/1/edit
  def edit
  end

  # POST /chat_templates
  # POST /chat_templates.json
  def create
    @chat_template = ChatTemplate.new(chat_template_params)

    respond_to do |format|
      if @chat_template.save
        format.html { redirect_to [:admin, @chat_template], notice: 'Чат-шаблон был успешно создан.' }
        format.json { render :show, status: :created, location: @chat_template }
      else
        format.html { render :new }
        format.json { render json: @chat_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chat_templates/1
  # PATCH/PUT /chat_templates/1.json
  def update
    respond_to do |format|
      if @chat_template.update(chat_template_params)
        format.html { redirect_to [:admin, @chat_template], notice: 'Чат-шаблон был успешно обновлён.' }
        format.json { render :show, status: :ok, location: @chat_template }
      else
        format.html { render :edit }
        format.json { render json: @chat_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chat_templates/1
  # DELETE /chat_templates/1.json
  def destroy
    @chat_template.destroy
    respond_to do |format|
      format.html { redirect_to admin_chat_templates_url, notice: 'Чат-шаблон был успешно удалён.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat_template
      @chat_template = ChatTemplate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chat_template_params
      params.require(:chat_template).permit(:text, :user_id)
    end
end
