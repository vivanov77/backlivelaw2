# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Role.destroy_all

# see config/application.rb
Rails.configuration.roles.each do |key,value|
  Role.create( name: key, title: value )
end

User.destroy_all

# http://stackoverflow.com/questions/4316940/create-a-devise-user-from-ruby-console
admin = User.find_or_create_by(email: "admin@example.com") { |u| u.password = "12345678"}
admin.add_role :admin
admin.first_name = "Admin"
# admin.confirm
admin.save!

user1 = User.find_or_create_by(email: "client1@example.com") { |u| u.password = "12345678"}
user1.add_role :client
user1.first_name = "John"
user1.last_name = "Smith"
# admin.confirm
user1.save!

user2 = User.find_or_create_by(email: "client2@example.com") { |u| u.password = "12345678" }
user2.add_role :client
user2.first_name = "Jack"
user2.last_name = "Johnson"
# admin.confirm
user2.save!

user3 = User.find_or_create_by(email: "lawyer1@example.com") { |u| u.password = "12345678" }
user3.add_role :lawyer
user3.first_name = "Jim"
# admin.confirm
user3.save!

user4 = User.find_or_create_by(email: "lawyer2@example.com") { |u| u.password = "12345678" }
user4.add_role :lawyer
user4.first_name = "Ted"
# admin.confirm
user4.save!

user5 = User.find_or_create_by(email: "jurist1@example.com") { |u| u.password = "12345678" }
user5.add_role :jurist
user5.first_name = "Max"
# admin.confirm
user5.save!

user6 = User.find_or_create_by(email: "jurist2@example.com") { |u| u.password = "12345678" }
user6.add_role :jurist
user6.first_name = "Larry"
# admin.confirm
user6.save!

client_emails_array = User.includes(:roles).where(:roles => {name: :client}).map(&:email)
# lawyer_emails_array = User.includes(:roles).where(:roles => {name: :lawyer}).map(&:email)
# jurist_emails_array = User.includes(:roles).where(:roles => {name: :jurist}).map(&:email)

Category.delete_all

["Category1", "Category2", "Category3", "Category4", "Category5"].each do |elem|

	Category.find_or_create_by name: elem

end

Question.delete_all

question_ids = []

["First", "Second", "Third", "Четвёртый", "Пятый", "Шестой", "Седьмой", "Восьмой", "Девятый", "Десятый"].each do |elem|

	question_ids << (Question.find_or_create_by title: elem)

end

subarray1 = question_ids.slice(0..question_ids.size/2)
subarray2 = question_ids.slice(question_ids.size/2+1..-1)

subarray1.each_with_index do |elem, index|

	q = Question.find(elem)
	q.categories << Category.first
	aindex = (index+1) % client_emails_array.size 
	user = User.find_by email: client_emails_array[aindex]
	q.user = user if user
	q.save!

end

subarray2.each_with_index do |elem, index|

	q = Question.find(elem)
	q.categories << Category.second
	aindex = (index+1) % client_emails_array.size 
	user = User.find_by email: client_emails_array[aindex]
	q.user = user if user	
	q.save!

end

Comment.delete_all

comment1 = Comment.find_or_create_by title: "Comment1", commentable_type: "Question", commentable_id: question_ids[0].id, user_id: user3.id
comment1.comments.create title: "Subcomment1_1", commentable_type: "Comment", commentable_id: comment1.id, user_id: user3.id
comment1.comments.create title: "Subcomment1_2", commentable_type: "Comment", commentable_id: comment1.id, user_id: user3.id


comment2 = Comment.find_or_create_by title: "Comment2", commentable_type: "Question", commentable_id: question_ids[1].id, user_id: user4.id
comment2.comments.create title: "Subcomment2_1", commentable_type: "Comment", commentable_id: comment2.id, user_id: user4.id
comment2.comments.create title: "Subcomment2_2", commentable_type: "Comment", commentable_id: comment2.id, user_id: user4.id

comment3 = Comment.find_or_create_by title: "Comment3", commentable_type: "Question", commentable_id: question_ids[2].id, user_id: user5.id
comment3.comments.create title: "Subcomment3_1", commentable_type: "Comment", commentable_id: comment3.id, user_id: user5.id
comment3.comments.create title: "Subcomment3_2", commentable_type: "Comment", commentable_id: comment3.id, user_id: user5.id

comment4 = Comment.find_or_create_by title: "Comment4", commentable_type: "Question", commentable_id: question_ids[2].id, user_id: user6.id
comment4.comments.create title: "Subcomment4_1", commentable_type: "Comment", commentable_id: comment4.id, user_id: user6.id
comment4.comments.create title: "Subcomment4_2", commentable_type: "Comment", commentable_id: comment4.id, user_id: user6.id

LibEntry.delete_all

lib_entry11 = LibEntry.find_or_create_by title: "Статья 1.1"
lib_entry12 = LibEntry.find_or_create_by title: "Статья 1.2"
lib_entry13 = LibEntry.find_or_create_by title: "Статья 1.3"

lib_entry21 = LibEntry.find_or_create_by title: "Статья 2.1", lib_entry_id: lib_entry11.id
lib_entry22 = LibEntry.find_or_create_by title: "Статья 2.2", lib_entry_id: lib_entry11.id

lib_entry23 = LibEntry.find_or_create_by title: "Статья 2.3", lib_entry_id: lib_entry12.id

lib_entry31 = LibEntry.find_or_create_by title: "Статья 3.1", lib_entry_id: lib_entry21.id

Message.delete_all

message = Message.create sender_id: user1.id, recipient_id: user2.id
sleep 1
message = Message.create sender_id: user3.id, recipient_id: user1.id
sleep 1
message = Message.create sender_id: user2.id, recipient_id: user4.id
sleep 1
message = Message.create sender_id: user1.id, recipient_id: user4.id
sleep 1
message = Message.create sender_id: user1.id, recipient_id: user2.id
sleep 1
message = Message.create sender_id: user3.id, recipient_id: user1.id
sleep 1
message = Message.create sender_id: user1.id, recipient_id: user3.id

DocRequest.delete_all

doc_request1 = DocRequest.create title: "Запрос документа1", text: "Текст запроса документа1", user_id: user1.id
doc_request2 = DocRequest.create title: "Запрос документа2 ", text: "Текст запроса документа2", user_id: user1.id
doc_request3 = DocRequest.create title: "Запрос документа3", text: "Текст запроса документа3", user_id: user1.id
doc_request4 = DocRequest.create title: "Запрос документа4", text: "Текст запроса документа4", user_id: user2.id
doc_request5 = DocRequest.create title: "Запрос документа5", text: "Текст запроса документа5", user_id: user2.id
doc_request6 = DocRequest.create title: "Запрос документа6", text: "Текст запроса документа6", user_id: user2.id

Doc.delete_all

doc1 = Doc.create text: "Текст документа1", price: 100, user_id: user3.id, doc_request_id: doc_request1.id
doc2 = Doc.create text: "Текст документа2", price: 200, user_id: user4.id, doc_request_id: doc_request2.id
doc3 = Doc.create text: "Текст документа3", price: 300, user_id: user5.id, doc_request_id: doc_request3.id
doc4 = Doc.create text: "Текст документа4", price: 400, user_id: user6.id, doc_request_id: doc_request4.id
doc5 = Doc.create text: "Текст документа5", price: 500, user_id: user3.id, doc_request_id: doc_request5.id
doc6 = Doc.create text: "Текст документа6", price: 600, user_id: user4.id, doc_request_id: doc_request6.id

ChatMessage.delete_all

chat_message1 = ChatMessage.create sendable_type: "User", sendable_id: user1.id, receivable_type: "User", receivable_id: user2.id, text: "Chat message 1"
sleep 1
chat_message2 = ChatMessage.create sendable_type: "User", sendable_id: user3.id, receivable_type: "User", receivable_id: user1.id, text: "Chat message 2"
sleep 1
chat_message3 = ChatMessage.create sendable_type: "User", sendable_id: user2.id, receivable_type: "User", receivable_id: user4.id, text: "Chat message 3"
sleep 1
chat_message4 = ChatMessage.create sendable_type: "User", sendable_id: user1.id, receivable_type: "User", receivable_id: user4.id, text: "Chat message 4"
sleep 1
chat_message5 = ChatMessage.create sendable_type: "User", sendable_id: user1.id, receivable_type: "User", receivable_id: user2.id, text: "Chat message 5"
sleep 1
chat_message6 = ChatMessage.create sendable_type: "User", sendable_id: user3.id, receivable_type: "User", receivable_id: user1.id, text: "Chat message 6"
sleep 1
chat_message7 = ChatMessage.create sendable_type: "User", sendable_id: user1.id, receivable_type: "User", receivable_id: user3.id, text: "Chat message 7"

Citation.delete_all

citation1 = Citation.create text: "Цитата1"
citation2 = Citation.create text: "Цитата2"
citation3 = Citation.create text: "Цитата3"
citation4 = Citation.create text: "Цитата4"
citation5 = Citation.create text: "Цитата5"
citation6 = Citation.create text: "Цитата6"

Feedback.delete_all

feedback1 = Feedback.create text: "Отзыв1", user_id: user1.id, email: user1.email, name: user1.last_name
feedback2 = Feedback.create text: "Отзыв2", user_id: user1.id, email: user1.email, name: user1.last_name
feedback3 = Feedback.create text: "Отзыв3", user_id: user1.id, email: user1.email, name: user1.last_name
feedback4 = Feedback.create text: "Отзыв4", user_id: user2.id, email: user2.email, name: user2.last_name
feedback5 = Feedback.create text: "Отзыв5", user_id: user2.id, email: user2.email, name: user2.last_name
feedback6 = Feedback.create text: "Отзыв6", user_id: user2.id, email: user2.email, name: user2.last_name

ChatTemplate.delete_all

chat_template1 = ChatTemplate.create text: "Шаблон ответа в чате1", user_id: user1.id
chat_template2 = ChatTemplate.create text: "Шаблон ответа в чате2", user_id: user1.id
chat_template3 = ChatTemplate.create text: "Шаблон ответа в чате3", user_id: user1.id
chat_template4 = ChatTemplate.create text: "Шаблон ответа в чате4", user_id: user2.id
chat_template5 = ChatTemplate.create text: "Шаблон ответа в чате5", user_id: user2.id
chat_template6 = ChatTemplate.create text: "Шаблон ответа в чате6", user_id: user2.id
