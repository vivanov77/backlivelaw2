class Admin::ChatTokensController < Admin::ApplicationController
  before_action :set_chat_token, only: [:show, :edit, :update, :destroy]

  # GET /chat_tokens
  # GET /chat_tokens.json
  def index
    @chat_tokens = ChatToken.eager_load(:user)
  end

  # GET /chat_tokens/1
  # GET /chat_tokens/1.json
  def show
  end

  # GET /chat_tokens/new
  def new
    @chat_token = ChatToken.new
  end

  # GET /chat_tokens/1/edit
  def edit
  end

  # POST /chat_tokens
  # POST /chat_tokens.json
  def create
    @chat_token = ChatToken.new(chat_token_params)

    respond_to do |format|
      if @chat_token.save
        format.html { redirect_to [:admin, @chat_token], notice: 'Чат-токен был успешно создан.' }
        format.json { render :show, status: :created, location: @chat_token }
      else
        format.html { render :new }
        format.json { render json: @chat_token.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chat_tokens/1
  # PATCH/PUT /chat_tokens/1.json
  def update
    respond_to do |format|
      if @chat_token.update(chat_token_params)
        format.html { redirect_to [:admin, @chat_token], notice: 'Чат-токен было успешно обновлён.' }
        format.json { render :show, status: :ok, location: @chat_token }
      else
        format.html { render :edit }
        format.json { render json: @chat_token.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chat_tokens/1
  # DELETE /chat_tokens/1.json
  def destroy
    @chat_token.destroy
    respond_to do |format|
      format.html { redirect_to admin_chat_tokens_url, notice: 'Чат-токен было успешно удалён.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat_token
      @chat_token = ChatToken.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chat_token_params
      params.require(:chat_token).permit(:chat_login, :chat_password)
    end
end
