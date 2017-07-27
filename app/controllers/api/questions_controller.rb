class Api::QuestionsController < Api::ApplicationController

  # include DeviseTokenAuth::Concerns::SetUserByToken

  # before_action :authenticate_user!
  # load_and_authorize_resource
    
  before_action :set_question, only: [:show, :update, :destroy]

  before_action :preview_questions_chars, only: [:show, :index]

  before_action :set_render_options, only: [:show, :index]

  after_action :mail_notification, only: [:create]

  # before_action :check_captcha, only: [:create]

  # before_action :register_user, only: [:create]

  # GET /questions
  def index

    @questions = Question

# Это неправильные ограничения:
    # if current_user

    #   if current_user.has_role? :client

    #     @questions = @questions.where(user_id: current_user.id)

    #   elsif (current_user.has_role?(:lawyer) || current_user.has_role?(:jurist))

    #      @questions = @questions.includes(:categories).

    #      where(categories: {id: (current_user.actual_purchased_categories.map &:id)})

    #   end

    # end

    if param? params[:charged]

      @questions = @questions.where(charged: true)

    end        

    if param? params[:unpaid]

      @questions = @questions.unpaid

    end

    if param? params[:paid]

      @questions = @questions.paid

    end


    if params[:category]

      @questions = @questions.includes(:categories).where(categories: {name: params[:category]})

    end

    @questions = @questions.all


    if params[:offset]

      collection = api_paginate(@questions) do |param_collection|

        ActiveModel::SerializableResource.new(

          param_collection.to_a,

          set_render_options
        )

      end      

      render json: collection

    else

      render( {json: @questions}.merge set_render_options )

    end



  end

  # GET /questions/1
  def show

    render( {json: @question}.merge set_render_options )

  end

  # POST /questions
  def create
    @question = Question.new(question_params)

    register_user

    if @question.save
      render( {json: @question, status: :created, location: [:api, @question]}.merge set_render_options)
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /questions/1
  def update
    # p question_params
    if @question.update(question_params)
      render json: @question
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  # DELETE /questions/1
  # def destroy
  #   @question.destroy
  #   render json: "Вопрос с id=\"#{@question.id}\" успешно удалён".to_json, status: :ok    
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def question_params
      # params.require(:question).permit(:title, :user_ids)

# https://www.simplify.ba/articles/2016/06/18/creating-rails5-api-only-application-following-jsonapi-specification/
# https://github.com/rails-api/active_model_serializers/blob/v0.10.6/docs/general/deserialization.md

      if params[:data] # JSON queries - default

        res = ActiveModelSerializers::Deserialization.jsonapi_parse(params)

      else # multipart form data - file upload
        
        res = params.require(:question).permit(:title, :text, :user_id, :category_ids, 
          file_containers_attributes: ["file", "@original_filename", "@content_type", "@headers", "_destroy", "id"])
      end

      if user_signed_in?

        res[:user_id] = current_user.id

      end

      res

    end

    def preview_questions_chars

      res = Configurable.found :preview_questions_chars

      if res
        @preview_questions_chars = res.value.to_i
      else
        @preview_questions_chars = 50
      end
    end

    def set_render_options

      show_categories = (param? params[:categories])

      show_user = (param? params[:user]) || params[:email]


      show_proposals = (param? params[:proposals])

      show_virtual_relation_payment = (param? params[:payment])


      show_cities = (param? params[:cities])

      show_comments = (param? params[:comments])

      show_file_containers = (param? params[:files])

      text_preview = (param? params[:text_preview])

      hash1 = [:user, :categories, :comments, :files, :proposals, :virtual_relation_payment]

      hash2 = hash1 + ["user.**"]


      render_conditions = 

      {

        show_user: show_user,

        show_categories: show_categories,

        show_proposals: show_proposals,
        
        show_virtual_relation_payment: show_virtual_relation_payment,


        show_cities: show_cities,

        text_preview: text_preview ? @preview_questions_chars : nil,      

        include: (params[:offset] ? hash1 : hash2)    
      }  

    end

    def mail_notification

      if current_user

        email = current_user.email

        token = nil

      elsif @email

        email = @email

        token = @user.confirmation_token

      end

        QuestionsMailer.question_created(@question, email, @password, token).deliver_now

    end

    def register_user

      if !current_user && params[:email]

        @email = params[:email]

        @password = User.random_password   

        register_login_tokenized_user @email, @password

        @question.user_id = @user.id

      end

    end
end