class Admin::ConfigurablesController < Admin::ApplicationController
	  # include the engine controller actions
  include ConfigurableEngine::ConfigurablesController

  before_action :set_configurable, only: [:show, :edit, :update, :destroy]

  # after_action :bind_tinymce_images_to_parent_configurable, only: [:update]

  # after_action :destroy_images, only: [:destroy]

  before_action :set_ctable, only: [:update]

  before_action :check_removed_attachment, only: [:update]

  def index

    @configurables = Configurable.get_all
    # @configurables_shoes = Configurable.get_part "shoes"
    # @configurables_components = Configurable.get_all_minus_part "shoes"    

  end

  def show
  end

  def edit

    @new = params[:new] 

  end

  def new

  	respond_to do |format|

      name = params[:name]

    	if name

    		@configurable = Configurable.create!(name: name, value: nil)

    		if @configurable
  		  	format.html { redirect_to edit_admin_configurable_path(@configurable, new: true), notice: 'Настройка была успешно создана.' }
  	    else
  		  	format.html { redirect_to admin_configurables_url, notice: 'Создать настройку не удалось.' }
  	    end
    	else
    		format.html { redirect_to admin_configurables_url, notice: 'Не указано имя создаваемой настройки.' }
    	end

  	end

  end

  def update
    respond_to do |format|
      if @configurable.update(configurable_params)
        format.html { redirect_to [:admin, @configurable], notice: 'Настройка была успешно обновлена.' }
        format.json { render :show, status: :ok, location: @configurable }
      else
        format.html { render :edit }
        format.json { render json: @configurable.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @configurable.destroy
    respond_to do |format|
      format.html { redirect_to admin_configurables_url, notice: 'Настройка была успешно удалена.' }
      format.json { head :no_content }
    end
  end  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_configurable
      @configurable = Configurable.find(params[:id])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def configurable_params
      params.require(:configurable).permit(:name, :value, :file, :chat_sound_free, :chat_sound_paid, :destroy_attachment, image_attributes: ["file", "@original_filename", "@content_type", "@headers"])
    end

    # def bind_tinymce_images_to_parent_configurable
    #   bind_tinymce_images_to_parent @configurable, :value
    # end

#     def destroy_images

#       images_orphaned = Image.where(imageable_id: params[:id])
# # http://stackoverflow.com/questions/831347/rails-why-does-findid-raise-an-exception-in-rails
#       if images_orphaned && !Configurable.find_by_id(params[:id])

#         images_orphaned.destroy_all

#       end

#     end


  def set_ctable

    @configurable = Configurable.find(params[:id]) unless @configurable

    if @configurable.ctyped?

      if params[:ctype_destroy]

        ctype_index = params[:ctype_index].to_i

        ctype_name = params[:ctype_name]

        res = @configurable.destroy_ctable_value ctype_index, ctype_name

  # http://stackoverflow.com/questions/5014804/rails-change-value-of-parameter-in-controller
        params[:configurable][:value] = res

      else

        ctype_hash = params[:ctype].to_unsafe_h

        if ctype_hash.values.join.blank?

          params[:configurable][:value] = @configurable.value

        else

          csubtype_hash = params[:csubtype] ? params[:csubtype].to_unsafe_h : nil

          res = @configurable.set_ctable ctype_hash, csubtype_hash

  # http://stackoverflow.com/questions/5014804/rails-change-value-of-parameter-in-controller
          params[:configurable][:value] = res

        end

      end

    end

  end

  def get_ctable

     @configurable = Configurable.find(params[:id]) unless @configurable

    if @configurable.ctyped?

      @configurable.get_ctable

    end

  end

  def check_removed_attachment

    da = params[:destroy_attachment]

    if da

      @configurable = Configurable.find(params[:id]) unless @configurable

      # @configurable.remove_file!

      @configurable.send "remove_#{@configurable.name}!"

      @configurable.save!

      # byebug

      # remove_file_directory @configurable.file
      remove_file_directory (@configurable.send @configurable.name.to_sym)
    end

  end  

end