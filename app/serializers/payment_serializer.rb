class PaymentSerializer < ActiveModel::Serializer
  attributes :id, :option, :sum, :cfrozen, :comment
  has_one :sender, if: -> { should_render_sender }
  has_one :recipient, if: -> { should_render_recipient }
  has_one :payment_type, if: -> { should_render_payment_type }

  def should_render_sender
  	@instance_options[:show_sender]
  end

  def should_render_recipient
  	@instance_options[:show_recipient]
  end

  def should_render_payment_type
  	@instance_options[:show_payment_type]
  end

end
