# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      protect_from_forgery with: :null_session
      skip_before_action :require_login

      def current_user
        @current_user ||= Jwt::UserAuthenticator.call(request.headers)
      end

      def authenticate
        render json: { errors: 'Unauthorized' }, status: :unauthorized unless current_user
      end
    end
  end
end
