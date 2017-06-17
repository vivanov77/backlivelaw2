class Api::QuestionsController < Api::ApplicationController

  # before_action :authenticate_user!
  # load_and_authorize_resource
    
  before_action :set_question, only: [:show, :update, :destroy]

#   def api_paginate_questions(scope, default_per_page = 20, show_categories = false, show_user = false, show_cities = false)
# # https://gist.github.com/be9/6446051
#     collection = scope.page(params[:offset]).per((params[:limit] || default_per_page).to_i)

#     current, total, per_page, total_count = collection.current_page, collection.total_pages, collection.limit_value, collection.total_count

#     collection = collection.to_a

#     result = collection.map do |elem|

#       h = {}

#       h[:question] = elem

#       h[:category] = elem.categories if show_categories

#       h[:user] = elem.user if show_user

#       h[:city] = elem.user.cities if show_cities

#       h

#     end

#     return {
#       pagination: {
#         current:  current,
#         previous: (current > 1 ? (current - 1) : nil),
#         next:     (current == total ? nil : (current + 1)),
#         limit:    per_page,
#         pages:    total,
#         count:    total_count
#       },
#       result: result
#     }
       
#   end

  # GET /questions
  def index

    @questions = Question.order(:id)


    show_categories = (param? params[:categories])

    show_user = (param? params[:user])

    show_cities = (param? params[:cities])


    if params[:category]

      @questions = @questions.includes(:categories).where(categories: {name: params[:category]})

    end

    if params[:offset]

      # @questions = api_paginate_questions(@questions, 20, show_categories, show_user, show_cities)

      collection = api_paginate(@questions) do |param_collection|

        # param_collection.formatted_users city, current_user.try(:id), params[:same_region], params[:other_regions]

        param_collection = param_collection.to_a

        result = param_collection.map do |elem|

          h = {}

          h[:question] = elem

          h[:category] = elem.categories if show_categories

          h[:user] = elem.user if show_user

          h[:city] = elem.user.cities if show_cities

          h

        end

      end      

      render json: collection

    else

      hash1 = [:categories, :user]

      hash2 = [:categories, :user, "user.**"]

      render json: @questions,

      show_categories: (param? params[:categories]),

      show_user: (param? params[:user]),

      show_cities: (param? params[:cities]),

      include: (params[:offset] ? hash1 : hash2)

    end

  end

  # GET /questions/1
  def show

    render json: @question,
    show_categories: (!(params[:categories] == "false") && !(params[:categories] == "nil") && params[:categories]),
    show_comments: (!(params[:comments] == "false") && !(params[:comments] == "nil") && params[:comments]),
    show_file_containers: (!(params[:files] == "false") && !(params[:files] == "nil") && params[:files]),

    include: [:categories, :comments, :files]

  end

  # POST /questions
  def create
    @question = Question.new(question_params)

    if @question.save
      render json: @question, status: :created, location: [:api, @question]
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /questions/1
  def update
    # p question_params
    if @question.update(question_params)
      render json: @question
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  # DELETE /questions/1
  # def destroy
  #   @question.destroy
  #   render json: "Вопрос с id=\"#{@question.id}\" успешно удалён".to_json, status: :ok    
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def question_params
      # params.require(:question).permit(:title, :user_ids)

# https://www.simplify.ba/articles/2016/06/18/creating-rails5-api-only-application-following-jsonapi-specification/
# https://github.com/rails-api/active_model_serializers/blob/master/docs/general/deserialization.md

      if params[:data] # JSON queries - default

        res = ActiveModelSerializers::Deserialization.jsonapi_parse(params)

      else # multipart form data - file upload
        
        res = params.require(:question).permit(:title, :text, :user_id, :category_ids, 
          file_containers_attributes: ["file", "@original_filename", "@content_type", "@headers", "_destroy", "id"])
      end

      if user_signed_in?

        res[:user_id] = current_user.id

      end

      res

    end 
end