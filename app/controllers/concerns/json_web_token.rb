require 'jwt'

module JsonWebToken
  extend ActiveSupport::Concern

  SECRET_KEY = Rails.application.secret_key_base

  def self.encode(payload, expiration = 7.days.from_now)
    payload[:expiration] = expiration.to_i

    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY).first

    HashWithIndifferentAccess.new decoded
  end
end
