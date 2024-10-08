# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


user = User.new(email: 'stu@test.com', password: '123456', role: 'admin', username: "Stuie")
user.save

user = User.new(email: 'ruth@test.com', password: '123456', username: "Rooty")
user.save

user = User.new(email: 'emi@test.com', password: '123456', username: "EmiM")
user.save

user = User.new(email: 'libby@test.com', password: '123456', username: "Libs")
user.save

user = User.new(email: 'dunc@test.com', password: '123456', username: "Teddy")
user.save

user = User.new(email: 'pete@test.com', password: '123456', username: "Pete")
user.save

user = User.new(email: 'chris@test.com', password: '123456', username: "Chris")
user.save

user = User.new(email: 'marc@test.com', password: '123456', username: "Marc")
user.save

user = User.new(email: 'spence@test.com', password: '123456', username: "Spence")
user.save
