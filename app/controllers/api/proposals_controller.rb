class Api::ProposalsController < Api::ApplicationController

  # before_action :authenticate_user!
  # load_and_authorize_resource
    
  before_action :set_proposal, only: [:show, :update, :destroy]

  # GET /proposals
  def index

    @proposals = Proposal.order(:id);

    render json: @proposals

  end

  # GET /proposals/1
  def show

    render json: @proposal

  end

  # POST /proposals
  def create
    @proposal = Proposal.new(proposal_params)

    if @proposal.save
      render json: @proposal, status: :created, location: [:api, @proposal]
    else
      render json: @proposal.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /proposals/1
  def update
    if @proposal.update(proposal_params)
      render json: @proposal
    else
      render json: @proposal.errors, status: :unprocessable_entity
    end
  end

  # DELETE /proposals/1
  def destroy
    @proposal.destroy
    render json: "Вопрос с id=\"#{@proposal.id}\" успешно удалён".to_json, status: :ok    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_proposal
      @proposal = Proposal.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def proposal_params
      # params.require(:proposal).permit(:title, :user_ids)

# https://www.simplify.ba/articles/2016/06/18/creating-rails5-api-only-application-following-jsonapi-specification/
# https://github.com/rails-api/active_model_serializers/blob/master/docs/general/deserialization.md

      res = ActiveModelSerializers::Deserialization.jsonapi_parse(params)

      if user_signed_in?

        res[:user_id] = current_user.id

      end

      res    

    end 
end