class Admin::MetroStationsController < Admin::ApplicationController
  before_action :set_metro_station, only: [:show]

  # GET /metro_stations
  # GET /metro_stations.json
  def index
    @metro_stations = MetroStation.all
  end

  # GET /metro_stations/1
  # GET /metro_stations/1.json
  def show
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_metro_station
      @metro_station = MetroStation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def metro_station_params
      params.require(:metro_station).permit(:name)
    end
end
