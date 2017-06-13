class Api::CitationsController < Api::ApplicationController
  before_action :set_citation, only: [:show]

  # GET /citations
  # GET /citations.json
  def index

    if param? params[:random]

      @citation = Citation.order("RANDOM()").first

      render json: @citation    

    else

      @citations = Citation.all

      render json: @citations

    end
  end

  # GET /citations/1
  # GET /citations/1.json
  def show
    render json: @citation
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_citation
      @citation = Citation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def citation_params
      params.require(:citation).permit(:text)
    end
end
