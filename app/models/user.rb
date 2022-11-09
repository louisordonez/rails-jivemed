class User < ApplicationRecord
  require 'securerandom'

  has_secure_password
  has_and_belongs_to_many :roles
  has_many :transactions

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email,
            presence: true,
            format: {
              with: URI::MailTo::EMAIL_REGEXP
            },
            uniqueness: true
  validates :email_verified, inclusion: [true, false]
  validates :password, presence: true, length: { minimum: 6 }, on: :create

  before_validation :set_default

  private

  def set_default
    self.email_verified = false if self.email_verified.nil?
  end
end
