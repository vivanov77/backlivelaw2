class QuestionSerializer < ActiveModel::Serializer

  attributes :id, :title, :text, :charged, :created_at, :updated_at
  has_many :comments, if: -> { should_render_comments }
  has_many :file_containers, if: -> { should_render_file_containers }
  has_many :categories, if: -> { should_render_categories }
  belongs_to :user, if: -> { should_render_user }
  has_many :proposals, if: -> { should_render_proposals }  
  has_one :virtual_relation_payment, if: -> { should_render_virtual_relation_payment }

# http://stackoverflow.com/questions/42244237/activemodel-serializers-has-many-with-condition-at-run-time
  def should_render_comments
  	@instance_options[:show_comments]
  end

  def text
    if @instance_options[:text_preview]

      preview_questions_chars = @instance_options[:text_preview]

      if object.text

        ind = object.text.slice(preview_questions_chars..-1).index(" ") + preview_questions_chars

        object.text.slice(0..ind) + "..."

      else
        nil
      end

    else
      object.text
    end
   end

  def should_render_file_containers
  	@instance_options[:show_file_containers]
  end

  def should_render_categories
  	@instance_options[:show_categories]
  end

  def should_render_user
    @instance_options[:show_user]
  end

  def should_render_proposals
    @instance_options[:show_proposals]
  end   

  def should_render_virtual_relation_payment
    @instance_options[:show_virtual_relation_payment]
  end
   
end