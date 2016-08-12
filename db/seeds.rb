# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# user
3.times do |n|
  admin = false
  email = Faker::Internet.email
  if n == 0
    admin = true
    email = 'admin@nogibook.com'
  end
  password = "password"
  name = email.match(/(.*)@/)[1]
  uid = User.create_unique_string  
  user = User.new email: email,
                  password: password,
                  password_confirmation: password,
                  name: name,
                  admin: admin,
                  uid: uid
  user.skip_confirmation!
  user.save!
end
  
# topic
User.all.each do |user|

  Topic.create! content: 'topic_test' + user.id.to_s,
                user_id: user.id
end

# comment
User.all.each_with_index do |user, i|
  topic = i + 2
  topic2 = i + 3
  if i == 2
    topic = 1
    topic2 = 2
  elsif i == 1
    topic2 = 1
  end
  Comment.create! content: 'comment_test ' + user.id.to_s + "to topic No.#{topic}",
                user_id: user.id,
                topic_id: topic
                
  Comment.create! content: 'comment_test ' + user.id.to_s + "to topic No.#{topic2}",
                user_id: user.id,
                topic_id: topic2
end