# frozen_string_literal: true

class PostsController < ApplicationController
  def index
    render :index, locals: { posts: Post.order(:published_at).page(params[:page]) }
  end

  def new
    render :new, locals: { post: Post.new(permitted_params) }
  end

  def show
    render locals: { post: post, comments: post.comments.order(:published_at).page(params[:page]) }
  end

  def edit
    render :edit, locals: { post: post }
  end

  def create
    Post.create! permitted_params.merge(user_id: current_user.id, published_at: Time.now)
    redirect_to posts_path, alert: 'Пост создан.'
  rescue ActiveRecord::RecordInvalid => e
    render :new, locals: { post: e.record }, alert: e.message
  end

  def update
    authorize_action_for post
    post.update! permitted_params
    redirect_to posts_path, alert: 'Пост изменен.'
  rescue ActiveRecord::RecordInvalid => e
    render :edit, locals: { post: e.record }, alert: e.message
  end

  def destroy
    authorize_action_for post
    post.destroy!
    redirect_to posts_path, alert: 'Пост удален.'
  rescue ActiveRecord::RecordInvalid => e
    redirect_to posts_path, alert: e.message
  end

  private

  def post
    @post ||= Post.find params[:id]
  end

  def permitted_params
    params.fetch(:post, {}).permit(:title, :body, :published_at)
  end
end
