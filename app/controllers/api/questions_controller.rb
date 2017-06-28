class Api::QuestionsController < Api::ApplicationController

  # before_action :authenticate_user!
  # load_and_authorize_resource
    
  before_action :set_question, only: [:show, :update, :destroy]

  before_action :preview_questions_chars, only: [:show, :index]

  # GET /questions
  def index

    @questions = Question.order(:id)


    show_categories = (param? params[:categories])

    show_user = (param? params[:user])

    show_cities = (param? params[:cities])

    text_preview = (param? params[:text_preview])

    hash1 = [:categories, :user]

    hash2 = [:categories, :user, "user.**"]


    render_conditions = 

    {
      show_categories: show_categories,
      
      show_user: show_user,

      show_cities: show_cities,

      text_preview: text_preview ? @preview_questions_chars : nil,      

      include: (params[:offset] ? hash1 : hash2)    
    }


    if params[:category]

      @questions = @questions.includes(:categories).where(categories: {name: params[:category]})

    end

    if params[:offset]

      collection = api_paginate(@questions) do |param_collection|

        ActiveModel::SerializableResource.new(

          param_collection.to_a,

          render_conditions
        )

      end      

      render json: collection

    else

      render( {json: @questions}.merge render_conditions )

    end

  end

  # GET /questions/1
  def show

    render json: @question,
    show_categories: (!(params[:categories] == "false") && !(params[:categories] == "nil") && params[:categories]),
    show_comments: (!(params[:comments] == "false") && !(params[:comments] == "nil") && params[:comments]),
    show_file_containers: (!(params[:files] == "false") && !(params[:files] == "nil") && params[:files]),

    text_preview: (param? params[:text_preview]) ? @preview_questions_chars : nil,

    include: [:categories, :comments, :files]

  end

  # POST /questions
  def create
    @question = Question.new(question_params)

    if @question.save
      render json: @question, status: :created, location: [:api, @question]
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
# https://github.com/rails-api/active_model_serializers/blob/master/docs/general/deserialization.md

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
end