# frozen_string_literal: true

module Jwt
  module TokenDecryptor
    extend self

    def call(token)
      decrypt(token)
    end

    private

    def decrypt(token)
      JWT.decode(token, ENV['JWT_SECRET_KEY'])
    rescue StandardError
      raise InvalidTokenError
    end
  end
end

class InvalidTokenError < StandardError; end
