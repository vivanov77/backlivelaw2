class Admin::ChatSessionsController < Admin::ApplicationController
  before_action :set_chat_session, only: [:show, :edit, :update, :destroy]

  # GET /chat_sessions
  # GET /chat_sessions.json
  def index

    @chat_sessions = ChatSession.all

  end

  # GET /chat_sessions/1
  # GET /chat_sessions/1.json
  def show
  end

  # GET /chat_sessions/new
  def new
    @chat_session = ChatSession.new
  end

  # GET /chat_sessions/1/edit
  def edit
  end

  # POST /chat_sessions
  # POST /chat_sessions.json
  def create
    @chat_session = ChatSession.new(chat_session_params)

    respond_to do |format|
      if @chat_session.save
        format.html { redirect_to [:admin, @chat_session], notice: 'Чат-сессия была успешно создана.' }
        format.json { render :show, status: :created, location: @chat_session }
      else
        format.html { render :new }
        format.json { render json: @chat_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chat_sessions/1
  # PATCH/PUT /chat_sessions/1.json
  def update
    respond_to do |format|
      if @chat_session.update(chat_session_params)
        format.html { redirect_to [:admin, @chat_session], notice: 'Чат-сессия была успешно обновлена.' }
        format.json { render :show, status: :ok, location: @chat_session }
      else
        format.html { render :edit }
        format.json { render json: @chat_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chat_sessions/1
  # DELETE /chat_sessions/1.json
  def destroy
    @chat_session.destroy
    respond_to do |format|
      format.html { redirect_to admin_chat_sessions_url, notice: 'Чат-сессия была успешно удалена.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat_session
      @chat_session = ChatSession.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chat_session_params
      params.require(:chat_session).permit(:specialist_id, :clientable_id, :clientable_type, :finished, :secret_chat_token)
    end
end
