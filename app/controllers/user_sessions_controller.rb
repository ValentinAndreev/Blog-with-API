# frozen_string_literal: true

class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    render :new, locals: { user: User.new }
  end

  def create
    if login user_params[:email], user_params[:password]
      redirect_back_or_to root_path, alert: 'Добро пожаловать!'
    else
      flash.now.alert = 'Неверный email или пароль.'
      new
    end
  end

  def destroy
    logout
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
