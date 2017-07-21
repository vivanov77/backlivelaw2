class Admin::DocResponsesController < Admin::ApplicationController
  before_action :set_doc_response, only: [:show, :edit, :update, :destroy]

  # GET /doc_responses
  # GET /doc_responses.json
  def index
    @doc_responses = DocResponse.all
  end

  # GET /doc_responses/1
  # GET /doc_responses/1.json
  def show
  end

  # GET /doc_responses/new
  def new
    @doc_response = DocResponse.new
  end

  # GET /doc_responses/1/edit
  def edit
  end

  # POST /doc_responses
  # POST /doc_responses.json
  def create
    @doc_response = DocResponse.new(doc_response_params)

    respond_to do |format|
      if @doc_response.save
        format.html { redirect_to [:admin, @doc_response], notice: 'Выполненный заказ на документ был успешно создан.' }
        format.json { render :show, status: :created, location: @doc_response }
      else
        format.html { render :new }
        format.json { render json: @doc_response.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /doc_responses/1
  # PATCH/PUT /doc_responses/1.json
  def update
    respond_to do |format|
      if @doc_response.update(doc_response_params)
        format.html { redirect_to [:admin, @doc_response], notice: 'Выполненный заказ на документ был успешно обновлён.' }
        format.json { render :show, status: :ok, location: @doc_response }
      else
        format.html { render :edit }
        format.json { render json: @doc_response.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /doc_responses/1
  # DELETE /doc_responses/1.json
  def destroy
    @doc_response.destroy
    respond_to do |format|
      format.html { redirect_to admin_doc_responses_url, notice: 'Выполненный заказ на документ был успешно удалён.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doc_response
      @doc_response = DocResponse.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def doc_response_params
      params.require(:doc_response).permit(:chosen, :text, :price, :user_id, :doc_request_id,
      :check_date, :complaint_date,
        file_containers_attributes: ["file", "@original_filename", "@content_type", "@headers", "_destroy", "id"])
    end
end
