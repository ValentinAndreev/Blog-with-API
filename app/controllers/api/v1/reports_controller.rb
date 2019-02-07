# frozen_string_literal: true

module Api
  module V1
    class ReportsController < BaseController
      def by_author
        return render json: { errors: 'Unauthorized' }, status: :unauthorized unless current_user
        return render json: { error: missing_params }, status: :unprocessable_entity unless missing_params.empty?

        render json: { message: 'Report generation started' }
        ReportGenerationJob.perform_later(params[:start_date], params[:end_date], params[:email])
      end

      private

      def missing_params
        %w[start_date end_date email] - params.keys
      end
    end
  end
end
