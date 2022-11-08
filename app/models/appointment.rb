class Appointment < ApplicationRecord
  has_many :schedules
  has_many :transactions
  has_and_belongs_to_many :users
end
