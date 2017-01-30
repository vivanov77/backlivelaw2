class Admin::UsersController < Admin::ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  before_action :check_for_questions, only: [:destroy]  

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/1/edit
  def edit
  end  

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to [:admin, @user], notice: 'Пользователь был успешно обновлён.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
  
    begin
      @user.destroy
      flash[:notice] = 'Пользователь был успешно удалён.'
    rescue Exception => e
      flash[:notice] = e.message
    end
	
    respond_to do |format|
	  format.html { redirect_to admin_users_url}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name)
    end

    def check_for_questions
      if @user.questions.any?

        error_message = "Пользователь: \"#{@user.email}\" не был удалён, потому что Вопрос c id=\"#{(@user.questions.collect {|question| question.title }).first}\" содержит его в своих атрибутах."

        respond_to do |format|
  # http://stackoverflow.com/questions/5254732/difference-between-map-and-collect-in-ruby        
          format.html { redirect_to admin_users_url, notice: error_message }
          format.json { head :no_content }
        end
      end
    end

end
