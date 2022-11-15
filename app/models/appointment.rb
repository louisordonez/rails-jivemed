class Appointment < ApplicationRecord
  belongs_to :user
  belongs_to :schedule
  belongs_to :user_transaction
end
