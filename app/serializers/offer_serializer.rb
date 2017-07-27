class OfferSerializer < ActiveModel::Serializer
  attributes :id, :price, :title, :text
  belongs_to :sender, if: -> { should_render_sender }
  belongs_to :recipient, if: -> { should_render_recipient }

  has_one :virtual_relation_payment, if: -> { should_render_virtual_relation_payment }

  def should_render_sender
    @instance_options[:show_sender]
  end

  def should_render_recipient
    @instance_options[:show_recipient]
  end

  def should_render_virtual_relation_payment
    @instance_options[:show_virtual_relation_payment]
  end

end
