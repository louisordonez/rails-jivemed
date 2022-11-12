require 'date'

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
admin.update(role_id: Role.find_by(name: 'admin').id)
admin.update(email_verified: true)

doctor =
  User.create(
    first_name: 'Maria',
    last_name: 'Dela Cruz',
    email: 'mdc.doctor@email.com',
    password: Rails.application.credentials.users.doctor_password
  )
doctor.update(role_id: Role.find_by(name: 'doctor').id)
doctor.update(email_verified: true)
doctor.departments << Department.find_by(name: 'Pediatrics')
doctor.create_doctor_fee(amount: 1000)

patient =
  User.create(
    first_name: 'Juan',
    last_name: 'Dela Cruz',
    email: 'jdc@email.com',
    password: Rails.application.credentials.users.patient_password
  )
patient.update(role_id: Role.find_by(name: 'patient').id)
patient.update(email_verified: true)

# schedule = Schedule.create(doctor_id: 2, date: Date.new(2022, 02, 02)) #YYYY-MM-DD

# appointment = Appointment.create(schedule_id: 1, user_id: 3)

# transaction = Transaction.create(appointment_id: 1)
