# frozen_string_literal: true

module Jwt
  module UserAuthenticator
    extend self

    def call(request_headers)
      @request_headers = request_headers

      begin
        payload, _header = Jwt::TokenDecryptor.call(token)
        return User.find(payload['user_id'])
      rescue StandardError
        return nil
      end
    end

    private

    def token
      @request_headers['Authorization'].split(' ').last
    end
  end
end
