class Api::CitiesController < Api::ApplicationController
  before_action :set_city, only: [:show]

  # GET /cities
  # GET /cities.json
  def index

    if params[:region_id]

      @regions = Region.where(id: params[:region_id])
      render json: @regions, include: [:cities], show_children: true

    elsif params[:ip]

      @iprange = Iprange.find_by_ip params[:ip]

      if @iprange

        render json: @iprange.city, include: [:region], show_parent: true

      else
        throw ActiveRecord::RecordNotFound
      end

    else

      @cities = City.all

      render json: @cities

    end
  end

  # GET /cities/1
  # GET /cities/1.json
  def show

    show_metro_lines = (param? params[:metro_lines])

    render json: @city, 

    show_metro_lines: show_metro_lines,
    
    include: :metro_lines
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
