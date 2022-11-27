roles = %w[admin doctor patient]
roles.each { |role| Role.create!(name: role) }

departments = %w[Pediatrics Psychiatry Orthodontics]
departments.each { |department| Department.create!(name: department) }

admin =
  User.create!(
    role_id: Role.find_by(name: 'admin').id,
    first_name: 'Jivemed',
    last_name: 'Admin',
    email: 'jivemed.admin@email.com',
    password: Rails.application.credentials.users.admin_password
  )
admin.update!(email_verified: true)

doctor1 =
  User.create!(
    role_id: Role.find_by(name: 'doctor').id,
    first_name: 'John',
    last_name: 'Doe',
    email: 'jd.doctor@email.com',
    password: Rails.application.credentials.users.doctor_password
  )
doctor1.update!(email_verified: true)
doctor1.departments << Department.find_by(name: 'Pediatrics')
doctor1.create_doctor_fee!(amount: 1000)

doctor2 =
  User.create!(
    role_id: Role.find_by(name: 'doctor').id,
    first_name: 'Maria',
    last_name: 'Dela Cruz',
    email: 'mdc.doctor@email.com',
    password: Rails.application.credentials.users.doctor_password
  )
doctor2.update!(email_verified: true)
doctor2.departments << Department.find_by(name: 'Psychiatry')
doctor2.create_doctor_fee!(amount: 1000)

patient =
  User.create!(
    role_id: Role.find_by(name: 'patient').id,
    first_name: 'Juan',
    last_name: 'Dela Cruz',
    email: 'jdc@email.com',
    password: Rails.application.credentials.users.patient_password
  )
patient.update!(email_verified: true)

schedule1 = Schedule.create!(user_id: doctor1.id, date: Date.parse('2022-01-31')) # YYYY-MM-DD
schedule2 = Schedule.create!(user_id: doctor2.id, date: Date.parse('2022-02-01')) # YYYY-MM-DD
