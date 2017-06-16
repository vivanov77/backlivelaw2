class Admin::LibEntriesController < Admin::ApplicationController
  before_action :set_lib_entry, only: [:show, :edit, :update, :destroy]
  before_action :set_parent_lib_entry, only: [:new, :edit]

  before_action :check_removed_attachment, only: [:update]

  # GET /lib_entries
  # GET /lib_entries.json
  def index

    if params[:lib_entry_id]
      @lib_entries = LibEntry.where(id: params[:lib_entry_id]).order(:title)
    else
      @lib_entries = LibEntry.where("lib_entry_id is null").order(:title)
    end
  end

  # GET /lib_entries/1
  # GET /lib_entries/1.json
  def show
  end

  # GET /lib_entries/new
  def new
    @lib_entry = LibEntry.new
  end

  # GET /lib_entries/1/edit
  def edit
  end

  # POST /lib_entries
  # POST /lib_entries.json
  def create
    @lib_entry = LibEntry.new(lib_entry_params)

    respond_to do |format|
      if @lib_entry.save
        format.html { redirect_to [:admin, @lib_entry], notice: 'Правовая статья была успешно создана.' }
        format.json { render :show, status: :created, location: @lib_entry }
      else
        format.html { render :new }
        format.json { render json: @lib_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lib_entries/1
  # PATCH/PUT /lib_entries/1.json
  def update
    respond_to do |format|
      if @lib_entry.update(lib_entry_params)
        format.html { redirect_to [:admin, @lib_entry], notice: 'Правовая статья была успешно обновлена.' }
        format.json { render :show, status: :ok, location: @lib_entry }
      else
        format.html { render :edit }
        format.json { render json: @lib_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lib_entries/1
  # DELETE /lib_entries/1.json
  def destroy
    @lib_entry.destroy
    respond_to do |format|
      format.html { redirect_to admin_lib_entries_url, notice: 'Правовая статья был успешно удалена.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lib_entry
      @lib_entry = LibEntry.find(params[:id])
    end

    def set_parent_lib_entry

      @selected = 0

      if params[:lib_entry_id]

        @selected = params[:lib_entry_id]

      end

      if params[:id]

        lib_entry = LibEntry.find(params[:id])

        @selected = lib_entry.lib_entry_id if lib_entry.lib_entry

      end

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lib_entry_params
      params.require(:lib_entry).permit(:title, :text, :lib_entry_id, :file, :data, :destroy_attachment)
    end

    def check_removed_attachment

      if params[:destroy_attachment]

        @lib_entry.remove_file!

        @lib_entry.save!

        remove_file_directory @lib_entry.file
        
      end

    end    
end
