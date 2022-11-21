class Schedule < ApplicationRecord
  belongs_to :user

  validates :date, presence: true
  validates :available, presence: true
end
