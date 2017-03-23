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
# admin.confirm
user1.save!

user2 = User.find_or_create_by(email: "client2@example.com") { |u| u.password = "12345678" }
user2.add_role :client
user2.first_name = "Jack"
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

user5 = User.find_or_create_by(email: "advocate1@example.com") { |u| u.password = "12345678" }
user5.add_role :advocate
user5.first_name = "Max"
# admin.confirm
user5.save!

user6 = User.find_or_create_by(email: "advocate2@example.com") { |u| u.password = "12345678" }
user6.add_role :advocate
user6.first_name = "Larry"
# admin.confirm
user6.save!

client_emails_array = User.includes(:roles).where(:roles => {name: :client}).map(&:email)
lawyers_emails_array = User.includes(:roles).where(:roles => {name: :lawyer}).map(&:email)
advocate_emails_array = User.includes(:roles).where(:roles => {name: :advocate}).map(&:email)

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