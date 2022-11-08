require 'date'

roles = %w[admin doctor patient]
roles.each { |role| Role.create(name: role) }

department = %w[Pediatrics Psychiatry Orthodontics]
department.each { |department| Department.create(name: department) }

admin =
  User.create!(
    first_name: 'Jivemed Admin',
    last_name: 'Jivemed Admin',
    email: 'jivemed.admin@email.com',
    password: "#{Rails.application.credentials.users.admin_password}"
  )
admin.update(email_verified: true)
admin.roles << Role.find_by(name: 'admin')

doctor =
  User.create!(
    first_name: 'Maria',
    last_name: 'Dela Cruz',
    email: 'mdc.doctor@email.com',
    password: "#{Rails.application.credentials.users.doctor_password}"
  )
doctor.update(email_verified: true)
doctor.roles << Role.find_by(name: 'doctor')
doctor.departments << Department.find_by(name: 'Pediatrics')
doctor.fees << Fee.create(amount: 1000.00)

patient =
  User.create!(
    first_name: 'Juan',
    last_name: 'Dela Cruz',
    email: 'jdc@email.com',
    password: "#{Rails.application.credentials.users.patient_password}"
  )
patient.update(email_verified: true)
patient.roles << Role.find_by(name: 'patient')

schedule = Schedule.create!(doctor_id: 2, date: Date.new(2022, 02, 02)) #YYYY-MM-DD

appointment = Appointment.create!(schedule_id: 1, user_id: 3)

transaction = Transaction.create!(appointment_id: 1)
