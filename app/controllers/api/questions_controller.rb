class Api::QuestionsController < Api::ApplicationController

  # before_action :authenticate_user!
  # load_and_authorize_resource
    
  before_action :set_question, only: [:show, :update, :destroy]

  # GET /questions
  def index

    @questions = Question.order(:id);

    if params[:category]

      @questions = @questions.includes(:categories).where(:categories => {name: params[:category]});

    end

    if params[:offset]

      @questions = api_paginate(@questions, 20)

    end

    render json: @questions

  end

  # GET /questions/1
  def show

    render json: @question,
    show_categories: (!(params[:categories] == "false") && !(params[:categories] == "nil") && params[:categories]),
    show_comments: (!(params[:comments] == "false") && !(params[:comments] == "nil") && params[:comments]),
    show_file_containers: (!(params[:files] == "false") && !(params[:files] == "nil") && params[:files]),

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
end