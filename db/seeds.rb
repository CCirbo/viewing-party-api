# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
User.create!(name: "Danny DeVito", username: "danny_de_v", password: "jerseyMikesRox7")
User.create!(name: "Dolly Parton", username: "dollyP", password: "Jolene123")
User.create!(name: "Lionel Messi", username: "futbol_geek", password: "test123")
User.create!(name: "Barbara", username: "leo_fan", password: "password123")
User.create!(name: "Ceci", username: "titanic_forever", password: "password123")
User.create!(name: "Peyton", username: "star_wars_geek_8", password: "password123")
User.create!(name: "John", username: "babylon_5", password: "password123")
User.create!(name: "Howard", username: "startrek_ng", password: "password123")
User.create!(name: "Cindy", username: "farscape_yay", password: "password123")
User.create!(name: "Val", username: "deep_space_9", password: "password123")
User.create!(name: "Rose", username: "foundations", password: "password123")