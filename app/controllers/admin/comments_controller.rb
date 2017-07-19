class Admin::CommentsController < Admin::ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :set_commentable, only: [:new, :create, :edit]

  # GET /comments
  # GET /comments.json
  def index

    if params[:comment_id]
      @comments = Comment.where(id: params[:comment_id])
    elsif params[:question_id]
      @comments = Question.where(id: params[:question_id])
    elsif params[:proposal_id]
      @comments = Proposal.where(id: params[:proposal_id])
    else
      @comments = Comment.order(:title)
    end

  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create

    @comment = @commentable.comments.new comment_params

    respond_to do |format|
      if @comment.save
        format.html { redirect_to [:admin, @comment], notice: 'Комментарий был успешно создан.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to [:admin, @comment], notice: 'Комментарий был успешно обновлён.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      # format.html { redirect_to admin_comments_url, notice: 'Комментарий был успешно удалён.' }
      format.html { redirect_to admin_questions_url, notice: 'Комментарий был успешно удалён.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
      @commentable = @comment.commentable
    end

    def set_commentable

      if params[:commentable_type] && params[:commentable_id]

        param_class = class_by_name params[:commentable_type]

        @commentable = param_class.find_by_id(params[:commentable_id])

      end

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:title, :text, :commentable_type, :commentable_id, :user_id)
    end
end
