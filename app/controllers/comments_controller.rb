# frozen_string_literal: true

class CommentsController < ApplicationController
  # rubocop:disable Metrics/AbcSize
  def create
    post.comments.create! permitted_params.merge(user_id: current_user.id, published_at: Time.now)

    flash.now.alert = 'Создан новый комментарий.'
  rescue ActiveRecord::RecordInvalid => e
    flash.now.alert = e.message
  ensure
    render 'posts/show', locals: { post: post, comments: post.comments.order(:published_at).page(params[:page]) }
  end

  def destroy
    post.comments.find(params[:id]).destroy!

    flash.now.alert = 'Комментарий удален.'
  rescue ActiveRecord::RecordInvalid => e
    flash.now.alert = e.message
  ensure
    render 'posts/show', locals: { post: post, comments: post.comments.order(:published_at).page(params[:page]) }
  end
  # rubocop:enable Metrics/AbcSize

  private

  def post
    @post ||= Post.find params[:post_id]
  end

  def permitted_params
    params.fetch(:comment, {}).permit(:body)
  end
end
