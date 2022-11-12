class Role < ApplicationRecord
  # has_and_belongs_to_many :users
  has_one :user

  validates :name, presence: true
end
