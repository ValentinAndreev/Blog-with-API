# frozen_string_literal: true

module Jwt
  module TokenProvider
    extend self

    def call(payload)
      issue_token(payload)
    end

    private

    def issue_token(payload)
      JWT.encode(payload.merge(exp: Time.now.to_i + 120), ENV['JWT_SECRET_KEY'])
    end
  end
end
