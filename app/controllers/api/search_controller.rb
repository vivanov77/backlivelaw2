class Api::SearchController < Api::ApplicationController
  def index

    @keyword = params[:keyword]

  	if params[:type]

  		case params[:type]

  		when "question"
  			result = Question.search @keyword
  		when "doc" || "doc_request" || "doc_response"
  			result = DocResponse.search @keyword
  		else
  			result = {error: "Неподдерживаемый тип поиска"}
  		end

	    render json: result, show_doc_request: true, include: [:doc_request]

  	else

	    @questions = Question.search @keyword

	    render json: @questions

  	end    

  end
end