class Api::QuestionsController < Api::ApplicationController
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
      render json: @question
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
    if @question.update(question_params)
      render json: [:api, @question]
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
      ActiveModelSerializers::Deserialization.jsonapi_parse(params)

    end
 
end