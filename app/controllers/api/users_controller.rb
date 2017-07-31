class Api::UsersController < Api::ApplicationController

  # before_action :authenticate_user!
  # load_and_authorize_resource
    
  before_action :set_user, only: [:show, :update, :destroy]

  before_action :check_for_questions, only: [:destroy]

  before_action :check_removed_avatar, only: [:update]

  before_action :set_render_options, only: [:show, :index]

  before_action :arrange_balance, only: [:show, :update]  

  # before_action :verify_owner
    
  # GET /users
  def index

    # http://localhost:3000/api/users?online=false&jurist=false&lawyer=true

    exception_roles = [:admin, :blocked]

    @users = User.includes(:roles).where.not(roles: {name: exception_roles }).includes(:cities)

    if param? params[:online]

      @users = @users.where(online: true)

    end

    params_array = []

    # city = nil

    # if param? params[:city_id]

    #   city = City.find params[:city_id]

    # end    

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
 
    if params[:offset]

      collection = api_paginate(@users) do |param_collection|

        ActiveModel::SerializableResource.new(

          param_collection.to_a,

          set_render_options
        )

      end      

      render json: collection

    else

      render( {json: @users}.merge set_render_options )

    end 

  end

  # GET /users/1
  def show
    render( {json: @user}.merge set_render_options )
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
# https://github.com/rails-api/active_model_serializers/blob/v0.10.6/docs/general/deserialization.md
      # ActiveModelSerializers::Deserialization.jsonapi_parse(params)

      if params[:data] # JSON queries - default

        res = ActiveModelSerializers::Deserialization.jsonapi_parse(params)

      else # multipart form data - file upload
        
        # res = params.require(:user).permit(:title, :text, :user_id, :category_ids, 
        #   file_containers_attributes: ["file", "@original_filename", "@content_type", "@headers", "_destroy", "id"])

        res = params.require(:user).permit(:first_name, :middle_name, :last_name, "dob(3i)", "dob(2i)",
         "dob(1i)", :active, :email_public, :phone, :experience, :qualification, :price, :balance,
         :university, :faculty, "dob_issue(3i)", "dob_issue(2i)", "dob_issue(1i)", :work, :staff,
         :role_ids, :city_ids, :avatar, :destroy_attachment,
         file_container_attributes: ["file", "@original_filename", "@content_type", "@headers", "_destroy", "id"])

      end

      res

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

    def check_removed_avatar

      if params[:destroy_attachment]

        @user.remove_avatar!

        @user.save!

        remove_file_directory @user.avatar     
        
      end

    end

    def set_render_options

      show_cities = (param? params[:cities])

      show_distance = (param? params[:distance])

      show_roles = (param? params[:roles])      

      show_balance = (param? params[:balance])      

      city_id = params[:city_id]

      show_actual_purchased_category_subscriptions = (param? params[:actual_purchased_category_subscriptions])

      show_purchased_category_subscriptions = (param? params[:purchased_category_subscriptions])      

      render_conditions = 

      {
        include: [:cities, :actual_purchased_category_subscriptions],

        show_cities: show_cities,

        show_roles: show_roles,

        show_virtual_relation_distance: show_distance,

        show_virtual_relation_balance: show_balance,        

        show_actual_purchased_category_subscriptions: show_actual_purchased_category_subscriptions,

        show_purchased_category_subscriptions: show_purchased_category_subscriptions,

        city_id: city_id
      }


    end

    def arrange_balance

      if params[:balance] && current_user

        payments = Payment.frozen_doc_response_payments @user.id

        payments.each do |payment|

          if payment.unfreeze_payment?

            payment.cfrozen = false

            payment.save!

            # p "payment unfrozen"

          end

          # p "payment not unfrozen"

        end

      end

    end

end