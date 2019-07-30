# frozen_string_literal: true

class Manager::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_guest
  before_action :find_user, only: %i[show edit update destroy]
  before_action :authorize_user

  def show
    @clients = if params[:name]
                 Client.where('name LIKE ?', "%#{params[:name]}%").page(params[:page])
               else
                 Client.page(params[:page])
               end
  end

  def find_user
    @user = User.find(params[:id])
  end

  def redirect_guest
    redirect_to root_path unless user_signed_in?
  end

  def redirect_namespace
    flash[:alert] = 'You can not access this namespace' unless current_user.manager?
    redirect_to admin_user_path(current_user) if current_user.admin?
    redirect_to user_path(current_user) if current_user.user?
  end

  def home_path
    return admin_user_path(current_user) if current_user.admin?
    return user_path(current_user) if current_user.user?
    return manager_user_path(current_user) if current_user.manager?
  end

  def authorize_user
    authorize @user
  end

  private

  def user_permit_params
    params.require(:user).permit(:email, :name, :password, :image)
  end
end
