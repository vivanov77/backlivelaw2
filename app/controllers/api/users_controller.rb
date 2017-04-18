class Api::UsersController < Api::ApplicationController

  # before_action :authenticate_user!
  # load_and_authorize_resource
    
  before_action :set_user, only: [:show, :update, :destroy]

  before_action :check_for_questions, only: [:destroy]

  # before_action :verify_owner

  before_action :mark_messages_read, only: [:update]

  before_action :unread_messages_count, only: [:show]
    
  # GET /users
  def index

    if params[:online]

      @users = User.where(online: true).order(:email)

      render json: @users

    else

      params_array = []

      if param? params[:lawyer]

        params_array << :lawyer

      end

      if param? params[:advocate]
        
        params_array << :advocate

      end

      if params_array.size > 0

        @users = User.includes(:roles).where(:roles => {name: params_array }).order(:email)

      else

        @users = []

      end

      render json: @users, show_roles: true

    end

  end

  # GET /users/1
  def show
    render json: @user, include: [:cities], show_cities: true
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # def destroy
  #   @user.destroy
  #   render json: "User with id=\"#{@user.id}\" deleted successfully".to_json, status: :ok
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      # params.require(:user).permit(:first_name)
# https://www.simplify.ba/articles/2016/06/18/creating-rails5-api-only-application-following-jsonapi-specification/
# https://github.com/rails-api/active_model_serializers/blob/master/docs/general/deserialization.md
      ActiveModelSerializers::Deserialization.jsonapi_parse(params)      
    end

    def check_for_questions
      if @user.questions.any?
        error_message = "Пользователь: \"#{@user.email}\" не был удалён, потому что Вопрос c id=\"#{(@user.questions.collect {|question| question.title }).first}\" содержит его в своих атрибутах."
        
        # render json: 'error'.to_json, status: :unprocessable_entity
        render json: { errors: error_message }, status: :unprocessable_entity

      end
    end

    def verify_owner

      # if params[:id].to_s != current_user.id.to_s

      #   error_message = "Пользователь не может менять данные чужого пользовательского профиля."
        
      #   render json: { errors: error_message }, status: :unprocessable_entity

      # end

    end

    def mark_messages_read

      if params[:mark_read] && (correspondent = User.find_by email: params[:mark_read])

        if Message.mark_messages_read @user.id, correspondent.id

          render json: @user

        else

          error_message = "Не удалось пометить прочитанными непрочитанные сообщения пользователя: \"#{@user.email}\"."
          
          render json: { errors: error_message }, status: :unprocessable_entity          

        end

      end

    end

    def unread_messages_count

      if params[:unread] && (correspondent = User.find_by email: params[:unread])

        unread = Message.unread_count @user.id, correspondent.id

        if unread

          mes_unread = {
            "messages": {
              "user_id": @user.id,
              "messages_unread": unread
            }
          }

          render json: mes_unread

        else

          error_message = "Не удалось подсчитать непрочитанные сообщения пользователя: \"#{@user.email}\"."
          
          render json: { errors: error_message }, status: :unprocessable_entity

        end
      end
    end  
end