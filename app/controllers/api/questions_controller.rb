class Api::QuestionsController < Api::ApplicationController
  before_action :set_question, only: [:show, :update, :destroy]
  # GET /questions
  def index

    @questions = Question.all;

    render json: api_paginate(@questions, 3)
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
      # render json: @question, status: :created
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
  def destroy
    @question.destroy
    render json: "Question with id=\"#{@question.id}\" deleted successfully".to_json, status: :ok    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def question_params
      params.require(:question).permit(:title, :user_ids)
    end
 
end