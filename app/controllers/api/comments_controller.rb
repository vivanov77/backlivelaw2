class Api::CommentsController < Api::ApplicationController

  before_action :authenticate_user!
  load_and_authorize_resource
    
  before_action :set_comment, only: [:show, :update, :destroy]

  # GET /comments
  # GET /comments.json
  def index

    if params[:comment_id]
      @comments = Comment.where(id: params[:comment_id])
      render json: @comments, include: [:comments], show_children: true
    elsif params[:question_id]
      @comments = Question.where(id: params[:question_id])
      render json: @comments, include: [:comments], show_children: true
    else
      @comments = Comment.order(:title)
      render json: @comments
    end

  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    render json: @comment
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      render json: @comment, status: :created, location: [:api, @comment]
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    if @comment.update(comment_params)
      render json: [:api, @comment]
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  # def destroy
  #   @comment.destroy
  #   render json: "Комментарий с id=\"#{@comment.id}\" успешно удалён".to_json, status: :ok    
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      # params.require(:comment).permit(:title)
# https://www.simplify.ba/articles/2016/06/18/creating-rails5-api-only-application-following-jsonapi-specification/
# https://github.com/rails-api/active_model_serializers/blob/master/docs/general/deserialization.md
      ActiveModelSerializers::Deserialization.jsonapi_parse(params)      
    end
end
