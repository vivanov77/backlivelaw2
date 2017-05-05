class Admin::GuestChatTokensController < Admin::ApplicationController
  before_action :set_guest_chat_token, only: [:show, :edit, :update, :destroy]

  # GET /guest_chat_tokens
  # GET /guest_chat_tokens.json
  def index
    @guest_chat_tokens = GuestChatToken.all
  end

  # GET /guest_chat_tokens/1
  # GET /guest_chat_tokens/1.json
  def show
  end

  # GET /guest_chat_tokens/new
  def new
    @guest_chat_token = GuestChatToken.new
  end

  # GET /guest_chat_tokens/1/edit
  def edit
  end

  # POST /guest_chat_tokens
  # POST /guest_chat_tokens.json
  def create
    @guest_chat_token = GuestChatToken.new(guest_chat_token_params)

    respond_to do |format|
      if @guest_chat_token.save
        format.html { redirect_to [:admin, @guest_chat_token], notice: 'Гостевой чат-токен был успешно создан.' }
        format.json { render :show, status: :created, location: @guest_chat_token }
      else
        format.html { render :new }
        format.json { render json: @guest_chat_token.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /guest_chat_tokens/1
  # PATCH/PUT /guest_chat_tokens/1.json
  def update
    respond_to do |format|
      if @guest_chat_token.update(guest_chat_token_params)
        format.html { redirect_to [:admin, @guest_chat_token], notice: 'Гостевой чат-токен было успешно обновлён.' }
        format.json { render :show, status: :ok, location: @guest_chat_token }
      else
        format.html { render :edit }
        format.json { render json: @guest_chat_token.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /guest_chat_tokens/1
  # DELETE /guest_chat_tokens/1.json
  def destroy
    @guest_chat_token.destroy
    respond_to do |format|
      format.html { redirect_to admin_guest_chat_tokens_url, notice: 'Гостевой чат-токен было успешно удалён.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_guest_chat_token
      @guest_chat_token = GuestChatToken.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def guest_chat_token_params
      params.require(:guest_chat_token).permit(:chat_login, :chat_password)
    end
end
