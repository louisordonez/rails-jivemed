class UserTransaction < ApplicationRecord
  belongs_to :user

  validates :email, presence: true
  validates :amount, presence: true
end
