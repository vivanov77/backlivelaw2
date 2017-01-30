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
user1 = User.find_or_create_by(email: "user1@example.com") { |u| u.password = "12345678"}
user1.add_role :client
user1.first_name = "John"
user1.save!

user2 = User.find_or_create_by(email: "user2@example.com") { |u| u.password = "12345678" }
user2.add_role :lawyer
user2.first_name = "Jack"
user2.save!