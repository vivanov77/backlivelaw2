unless ENV["DYNO"]
ThinkingSphinx::Index.define :message, :with => :active_record, :delta => true do
	indexes text

	indexes sender.email, :as => :sender_email, :sortable => true

	indexes recipient.email, :as => :recipient_email, :sortable => true	

	# indexes [sender.email, recipient.email], :as => :messager_email, :sortable => true

	has sender_id, created_at, updated_at

	has recipient_id

end

end

# 1. Поиск в списке цепочек по собеседнику
# 2. Поиск в цепочке по сообщению