class Admin::MetroLinesController < Admin::ApplicationController
  before_action :set_metro_line, only: [:show]

  # GET /metro_lines
  # GET /metro_lines.json
  def index   
  # https://stackoverflow.com/questions/15847347/rails-where-attribute-is-not-null

    @metroables = Region.includes(:metro_lines).where.not(metro_lines: {metroable_id: nil}).to_a

    @metroables += City.includes(:metro_lines).where.not(metro_lines: {metroable_id: nil}).to_a

  end

  # GET /metro_lines/1
  # GET /metro_lines/1.json
  def show
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_metro_line
      @metro_line = MetroLine.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def metro_line_params
      params.require(:metro_line).permit(:name, :hex_color)
    end
end
