# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    render locals: { user: User.new }
  end

  def edit
    render :edit, locals: { user: current_user }
  end

  def create
    auto_login User.create!(user_params)
    redirect_to root_path
  rescue ActiveRecord::RecordInvalid => e
    flash.now.alert = e.message
    render :new, locals: { user: e.record }
  end

  def update
    current_user.update(user_params)
    redirect_to edit_user_path(current_user), alert: message
  end

  private

  def user_params
    params.require(:user).permit(:nickname, :email, :password, :password_confirmation, :avatar)
  end

  def message
    current_user.errors.full_messages.join(', ').presence || 'Профиль изменен.'
  end
end
