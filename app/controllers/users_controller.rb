# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_guest
  before_action :shorten_params, only: %i[update update_password]
  before_action :find_user, only: %i[show edit update destroy change_password update_password]
  before_action :authorize_user, only: %i[show edit update destroy change_password update_password]

  def show; end

  def edit; end

  def change_password; end

  def update_password
    if current_user.valid_password?(@user_params[:password])
      validate_and_confirm_password_update
    else
      @user.errors.add(:password, 'Current password does not match')
      render :change_password
    end
  end

  def update
    if @user.update(user_permit_params)
      redirect_to home_path, notice: 'User successfully updated'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to home_path, notice: 'Sorry to see you go!'
  end

  def find_user
    @user = User.find(params[:id])
  end

  def redirect_guest
    redirect_to root_path unless user_signed_in?
  end

  def home_path
    return admin_user_path(current_user) if current_user.admin?
    return user_path(current_user) if current_user.user?
    return manager_user_path(current_user) if current_user.manager?
  end

  def authorize_user
    authorize @user
  end

  def shorten_params
    @user_params = params[:user]
  end

  private

  def user_permit_params
    params.require(:user).permit(:email, :name, :password, :image)
  end

  def confirm_password_update
    if @user_params[:new_password] == @user_params[:confirm_password]
      @user.update(password: @user_params[:new_password])
      sign_in(@user, bypass: true)
      redirect_to home_path, notice: 'Password successfully changed'
    else
      @user.errors.add(:new_password, 'Password confirmations do not match')
      render :change_password
    end
  end

  def validate_and_confirm_password_update
    if @user_params[:new_password].present?
      confirm_password_update
    else
      @user.errors.add(:new_password, 'Please enter a new password to update')
      render :change_password
    end
  end
end
