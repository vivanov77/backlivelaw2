class Admin::CitiesController < Admin::ApplicationController
  before_action :set_city, only: [:show]

  # GET /cities
  # GET /cities.json
  def index
    @cities = City.all
  end

  # GET /cities/1
  # GET /cities/1.json
  def show
  end  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_city
      @city = City.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def city_params
      params.require(:city).permit(:kladr_code, :name, :kladr_type_short, :kladr_type, :latitude, :longitude, :region_id)
    end
end
