class Fee < ApplicationRecord
  has_and_belongs_to_many :users

  validates :amount, presence: true
end
