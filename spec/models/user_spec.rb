require 'rails_helper'

RSpec.describe User, type: :model do
  context 'before user creation' do
    it 'should have a first name' do
      expect {
        User.create!(
          last_name: 'last name',
          email: 'email@email.com',
          password: 'password'
        )
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should have a last name' do
      expect {
        User.create!(
          first_name: 'first name',
          email: 'email@email.com',
          password: 'password'
        )
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should have a password' do
      expect {
        User.create!(
          first_name: 'first name',
          last_name: 'last name',
          email: 'email@email.com'
        )
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should have a minimum password length of 6' do
      expect {
        User.create!(
          first_name: 'first name',
          last_name: 'last name',
          email: 'email@email.com',
          password: '12345'
        )
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context 'upon user creation' do
    it 'should not have a verified email' do
      roles = %w[admin doctor patient]
      roles.each { |role| Role.create!(name: role) }

      user =
        User.create!(
          role_id: Role.find_by(name: 'patient').id,
          first_name: 'first name',
          last_name: 'last name',
          email: 'email@email.com',
          password: '123456'
        )

      expect(user.email_verified?).to eq(false)
    end
  end

  context 'upon doctor user creation' do
    it 'should have a doctor role' do
      roles = %w[admin doctor patient]
      roles.each { |role| Role.create!(name: role) }

      doctor =
        User.create!(
          role_id: Role.find_by(name: 'doctor').id,
          first_name: 'doctor first name',
          last_name: 'doctor last name',
          email: 'doctor.email@email.com',
          password: '123456'
        )

      expect(doctor.role_id).to eq(Role.find_by(name: 'doctor').id)
    end

    it 'should have a department' do
      roles = %w[admin doctor patient]
      roles.each { |role| Role.create!(name: role) }

      departments = %w[Pediatrics Psychiatry Orthodontics]
      departments.each { |department| Department.create!(name: department) }

      doctor =
        User.create!(
          role_id: Role.find_by(name: 'doctor').id,
          first_name: 'doctor first name',
          last_name: 'doctor last name',
          email: 'doctor.email@email.com',
          password: '123456'
        )
      doctor.departments << Department.find_by(name: 'Pediatrics')

      expect(doctor.departments.first).to eq(
        Department.find_by(name: 'Pediatrics')
      )
    end
  end

  context 'upon patient user creation' do
    it 'should have a patient role' do
      roles = %w[admin doctor patient]
      roles.each { |role| Role.create!(name: role) }

      user =
        User.create!(
          role_id: Role.find_by(name: 'patient').id,
          first_name: 'patient first name',
          last_name: 'patient last name',
          email: 'patient.email@email.com',
          password: '123456'
        )

      expect(user.role_id).to eq(Role.find_by(name: 'patient').id)
    end
  end
end
