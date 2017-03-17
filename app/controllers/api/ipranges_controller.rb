class Api::IprangesController < Api::ApplicationController
  before_action :set_iprange, only: [:show, :update, :destroy]

  # GET /ipranges
  # GET /ipranges.json
  def index

      @ipranges = Iprange.all

      render json: @ipranges

  end

  # GET /ipranges/1
  # GET /ipranges/1.json
  def show
    render json: @iprange    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_iprange
      @iprange = Iprange.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def iprange_params
      params.require(:iprange).permit(:ip_block_start, :ip_block_end, :ip_range, :kladr_city_code, :city_id, :ip)
    end
end
