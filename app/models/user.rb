class User < ApplicationRecord
  require 'securerandom'

  has_secure_password
  has_and_belongs_to_many :roles
  has_many :appointments

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
  validates :stripe_id, presence: true

  before_validation :set_default
  before_validation :create_on_stripe, on: :create

  def create_on_stripe
    params = { email: email, name: "#{first_name} #{last_name}" }
    response = Stripe::User.create(params)

    self.stripe_id = response.id
  end

  private

  def set_default
    self.email_verified = false if self.email_verified.nil?
  end
end
