class Api::RegionsController < Api::ApplicationController
  before_action :set_region, only: [:show]

  # GET /regions
  # GET /regions.json
  def index

    @regions = Region.all

    render json: @regions

  end

  # GET /regions/1
  # GET /regions/1.json
  def show
    render json: @region
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_region
      @region = Region.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def region_params
      params.require(:region).permit(:kladr_code, :name, :kladr_type_short, :kladr_type)
    end
end
