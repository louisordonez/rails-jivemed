# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

roles = %w[admin patient doctor]
roles.each { |role| Role.create(name: role) }

admin =
  User.create!(
    first_name: 'Jivemed Admin',
    last_name: 'Jivemed Admin',
    email: 'jivemed.admin@email.com',
    password: "#{Rails.application.credentials.users.admin_password}"
  )
admin.roles << Role.find_by(name: 'admin')
admin.update(email_verified: true)
