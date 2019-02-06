# frozen_string_literal: true

module Api
  module V1
    class SessionsController < BaseController
      def create
        user = User.authenticate(params[:email], params[:password])

        if user
          token = Jwt::TokenProvider.call(user_id: user.id)
          render json: { user: user, token: token }
        else
          render json: { error: 'Invalid email or password.' }, status: :unauthorized
        end
      end
    end
  end
end
