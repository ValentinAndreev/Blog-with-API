# frozen_string_literal: true

class CommentsController < ApplicationController
  # rubocop:disable Metrics/AbcSize
  def create
    post.comments.create! permitted_params.merge(user_id: current_user.id, published_at: Time.now)
    redirect_to post_path(post), alert: 'Комментарий создан.'
  rescue ActiveRecord::RecordInvalid => e
    redirect_to post_path(post), alert: e.message
  end
  # rubocop:enable Metrics/AbcSize

  def destroy
    authorize_action_for comment
    comment.destroy!
    redirect_to post_path(post), alert: 'Комментарий удален.'
  rescue ActiveRecord::RecordInvalid => e
    redirect_to post_path(post), alert: e.message
  end

  private

  def post
    @post ||= Post.find params[:post_id]
  end

  def comment
    post.comments.find(params[:id])
  end

  def permitted_params
    params.fetch(:comment, {}).permit(:body)
  end
end
