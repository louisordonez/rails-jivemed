class Transaction < ApplicationRecord
  belongs_to :user
  has_one :appointment
end
