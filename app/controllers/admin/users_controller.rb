class Admin::UsersController < Admin::ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  before_action :check_for_questions, only: [:destroy]

  before_action :check_removed_avatar, only: [:update]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/1/edit
  def edit
  end  

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to [:admin, @user], notice: 'Пользователь был успешно обновлён.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
  
    begin
      @user.destroy
      flash[:notice] = 'Пользователь был успешно удалён.'
    rescue Exception => e
      flash[:notice] = e.message
    end
	
    respond_to do |format|
	  format.html { redirect_to admin_users_url}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :middle_name, :last_name, "dob(3i)", "dob(2i)",
       "dob(1i)", :active, :email_public, :phone, :experience, :qualification, :price, :balance,
       :university, :faculty, "dob_issue(3i)", "dob_issue(2i)", "dob_issue(1i)", :work, :staff,
       :role_ids, :city_ids, :avatar, :destroy_attachment,
       file_container_attributes: ["file", "@original_filename", "@content_type", "@headers", "_destroy", "id"])
    end

    def check_for_questions
      if @user.questions.any?

        error_message = "Пользователь: \"#{@user.email}\" не был удалён, потому что Вопрос c id=\"#{(@user.questions.collect {|question| question.title }).first}\" содержит его в своих атрибутах."

        respond_to do |format|
  # http://stackoverflow.com/questions/5254732/difference-between-map-and-collect-in-ruby        
          format.html { redirect_to admin_users_url, notice: error_message }
          format.json { head :no_content }
        end
      end
    end

    def check_removed_avatar

      if params[:destroy_attachment]

        @user.remove_avatar!

        @user.save!

        remove_file_directory @user.avatar     
        
      end

    end

end
