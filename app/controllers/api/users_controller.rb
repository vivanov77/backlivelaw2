class Api::UsersController < Api::ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  before_action :check_for_questions, only: [:destroy]
    
  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: [:api, @user]
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    render json: "User with id=\"#{@user.id}\" deleted successfully".to_json, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:first_name)
    end

    def check_for_questions
      if @user.questions.any?
        error_message = "Пользователь: \"#{@user.email}\" не был удалён, потому что Вопрос c id=\"#{(@user.questions.collect {|question| question.title }).first}\" содержит его в своих атрибутах."
        
        # render json: 'error'.to_json, status: :unprocessable_entity
        render json: { errors: error_message }, status: :unprocessable_entity

      end
    end 
end