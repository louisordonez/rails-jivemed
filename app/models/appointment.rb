class Appointment < ApplicationRecord
  belongs_to :user
  belongs_to :schedule
  belongs_to :user_transaction

  validates :user_id, presence: true
  validates :schedule_id, presence: true
  validates :user_transaction_id, presence: true
end
