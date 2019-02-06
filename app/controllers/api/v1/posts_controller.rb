# frozen_string_literal: true

module Api
  module V1
    class PostsController < BaseController
      before_action :authenticate

      def show
        render json: Post.find(params[:post_id])
      end

      def index
        add_headers
        render json: Post.page(params[:page]).per(page_limit).order(published_at: :desc)
      end

      def create
        post = Post.create! post_params
        render json: post
      rescue ActiveRecord::RecordInvalid => e
        render json: { errors: e.message.partition('Validation failed: ').last.split(', ') }, status: :unprocessable_entity
      end

      private

      def page_limit
        @page_limit ||= params[:per_page] || Post.default_per_page
      end

      def post_params
        { title: params[:title], body: params[:body], user: current_user, published_at: params[:published_at] || Time.now }
      end

      def add_headers
        response.headers['Total-pages'] = (Post.count / page_limit.to_f).ceil
        response.headers['Total-records'] = Post.count
      end
    end
  end
end
