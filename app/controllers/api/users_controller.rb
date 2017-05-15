class Api::UsersController < Api::ApplicationController

  # before_action :authenticate_user!
  # load_and_authorize_resource
    
  before_action :set_user, only: [:show, :update, :destroy]

  before_action :check_for_questions, only: [:destroy]

  # before_action :verify_owner
    
  # GET /users
  def index

    # http://localhost:3000/api/users?online=false&jurist=false&lawyer=true

    exception_roles = [:admin, :blocked]

    @users = User.includes(:roles).where.not(roles: {name: exception_roles })

    if param? params[:online]

      @users = @users.where(online: true)

    end

    params_array = []

    if param? params[:lawyer]

      params_array << :lawyer

    end

    if param? params[:jurist]
      
      params_array << :jurist

    end

    if param? params[:client]
      
      params_array << :client

    end    

    if params_array.size > 0

      @users = @users.includes(:roles).where(roles: {name: params_array })

    end

    @users = @users.order(:email)

    render json: @users, show_roles: true

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


end