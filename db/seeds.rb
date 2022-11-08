require 'date'

roles = %w[admin doctor patient]
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

doctor =
  User.create!(
    first_name: 'Maria',
    last_name: 'Dela Cruz',
    email: 'mdc.doctor@email.com',
    password: "#{Rails.application.credentials.users.doctor_password}"
  )
doctor.roles << Role.find_by(name: 'doctor')
doctor.update(email_verified: true)

patient =
  User.create!(
    first_name: 'Juan',
    last_name: 'Dela Cruz',
    email: 'jdc@email.com',
    password: "#{Rails.application.credentials.users.patient_password}"
  )
patient.roles << Role.find_by(name: 'patient')
patient.update(email_verified: true)

schedule = Schedule.create!(doctor_id: 2, date: Date.new(2022, 2, 02)) #YYYY-MM-DD

appointment = Appointment.create!(schedule_id: 1, user_id: 3)

transaction = Transaction.create!(appointment_id: 1)
