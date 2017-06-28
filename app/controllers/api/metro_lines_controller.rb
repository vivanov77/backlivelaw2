class Api::MetroLinesController < Api::ApplicationController
  before_action :set_metro_line, only: [:show]

  # GET /metro_lines
  # GET /metro_lines.json
  def index

      @metro_lines = MetroLine.all

      render json: @metro_lines

  end

  # GET /metro_lines/1
  # GET /metro_lines/1.json
  def show

    show_metro_stations = (param? params[:metro_stations])


    render json: @metro_line, 

    show_metro_stations: show_metro_stations,
    
    include: :metro_stations
  end  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_metro_line
      @metro_line = MetroLine.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def metro_line_params
      params.require(:metro_line).permit(:name)
    end
end
