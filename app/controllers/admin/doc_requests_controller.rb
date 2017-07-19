class Admin::DocRequestsController < Admin::ApplicationController
  before_action :set_doc_request, only: [:show, :edit, :update, :destroy]

  # GET /doc_requests
  # GET /doc_requests.json
  def index
    @doc_requests = DocRequest.all
  end

  # GET /doc_requests/1
  # GET /doc_requests/1.json
  def show
  end

  # GET /doc_requests/new
  def new
    @doc_request = DocRequest.new
  end

  # GET /doc_requests/1/edit
  def edit
  end

  # POST /doc_requests
  # POST /doc_requests.json
  def create
    @doc_request = DocRequest.new(doc_request_params)

    respond_to do |format|
      if @doc_request.save
        format.html { redirect_to [:admin, @doc_request], notice: 'Запрос на документ был успешно создан.' }
        format.json { render :show, status: :created, location: @doc_request }
      else
        format.html { render :new }
        format.json { render json: @doc_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /doc_requests/1
  # PATCH/PUT /doc_requests/1.json
  def update
    respond_to do |format|
      if @doc_request.update(doc_request_params)
        format.html { redirect_to [:admin, @doc_request], notice: 'Запрос на документ был успешно обновлён.' }
        format.json { render :show, status: :ok, location: @doc_request }
      else
        format.html { render :edit }
        format.json { render json: @doc_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /doc_requests/1
  # DELETE /doc_requests/1.json
  def destroy
    @doc_request.destroy
    respond_to do |format|
      format.html { redirect_to admin_doc_requests_url, notice: 'Запрос на документ был успешно удалён.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doc_request
      @doc_request = DocRequest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def doc_request_params
      params.require(:doc_request).permit(:title, :text, :user_id, :category_ids, 
        file_containers_attributes: ["file", "@original_filename", "@content_type", "@headers", "_destroy", "id"])
    end
end
