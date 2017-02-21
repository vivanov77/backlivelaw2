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
admin.save!

user1 = User.find_or_create_by(email: "user1@example.com") { |u| u.password = "12345678"}
user1.add_role :client
user1.first_name = "John"
user1.save!

user2 = User.find_or_create_by(email: "user2@example.com") { |u| u.password = "12345678" }
user2.add_role :lawyer
user2.first_name = "Jack"
user2.save!

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

subarray1.each do |elem|

	q = Question.find(elem)
	q.categories << Category.first
	q.save!

end

subarray2.each do |elem|

	q = Question.find(elem)
	q.categories << Category.second
	q.save!

end

Comment.delete_all

comment1 = Comment.find_or_create_by title: "Comment1", commentable_type: "Question", commentable_id: question_ids[0].id, user_id: user1.id
comment1.comments.create title: "Subcomment1_1", commentable_type: "Comment", commentable_id: comment1.id, user_id: user1.id
comment1.comments.create title: "Subcomment1_2", commentable_type: "Comment", commentable_id: comment1.id, user_id: user1.id


comment2 = Comment.find_or_create_by title: "Comment2", commentable_type: "Question", commentable_id: question_ids[1].id, user_id: user1.id
comment2.comments.create title: "Subcomment2_1", commentable_type: "Comment", commentable_id: comment2.id, user_id: user1.id
comment2.comments.create title: "Subcomment2_2", commentable_type: "Comment", commentable_id: comment2.id, user_id: user1.id

comment3 = Comment.find_or_create_by title: "Comment3", commentable_type: "Question", commentable_id: question_ids[2].id, user_id: user1.id
