class Api::SearchController < Api::ApplicationController
  def index
    @keyword = params[:keyword]

    @questions = Question.search @keyword

    render json: @questions

  end
end