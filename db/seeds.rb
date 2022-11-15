roles = %w[admin doctor patient]
roles.each { |role| Role.create(name: role) }

departments = %w[Pediatrics Psychiatry Orthodontics]
departments.each { |department| Department.create(name: department) }

admin =
  User.create(
    first_name: 'Jivemed Admin',
    last_name: 'Jivemed Admin',
    email: 'jivemed.admin@email.com',
    password: Rails.application.credentials.users.admin_password
  )
admin.update(email_verified: true)
admin.update(role_id: Role.find_by(name: 'admin').id)

doctor =
  User.create(
    first_name: 'Maria',
    last_name: 'Dela Cruz',
    email: 'mdc.doctor@email.com',
    password: Rails.application.credentials.users.doctor_password
  )
doctor.update(email_verified: true)
doctor.update(role_id: Role.find_by(name: 'doctor').id)
doctor.departments << Department.find_by(name: 'Pediatrics')
doctor.create_doctor_fee(amount: 1000)

patient =
  User.create(
    first_name: 'Juan',
    last_name: 'Dela Cruz',
    email: 'jdc@email.com',
    password: Rails.application.credentials.users.patient_password
  )
patient.update(email_verified: true)
patient.update(role_id: Role.find_by(name: 'patient').id)

schedule = Schedule.create(user_id: doctor.id, date: Date.parse('2022-01-31')) #YYYY-MM-DD

# appointment = Appointment.create(schedule_id: 1, user_id: 3)

transaction =
  Transaction.create(
    user_id: patient.id,
    email: patient.email,
    stripe_id: 'test_stripe_id_123456',
    amount: 1_333_425.to_f / 100
  )
