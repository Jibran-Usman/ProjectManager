# frozen_string_literal: true

class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  # before_action :redirect_guest
  before_action :find_user, only: %i[edit update toggle destroy]
  # before_action :authorize_user, only: %i[edit update toggle destroy]

  def new
    @user = User.new
    authorize @user
  end

  def create
    @user = User.new(user_permit_params)
    authorize @user

    if @user.save
      redirect_to home_path, notice: 'User succesfully created'
    else
      render 'new'
    end
  end

  def edit; end

  def update
    if @user.update(user_permit_params)
      redirect_to home_path, notice: 'User succesfully updated'
    else
      render 'edit'
    end
  end

  def show
    @users = if params[:name]
               User.where('name LIKE ?', "%#{params[:name]}%").page(params[:page])
             else
               User.page(params[:page])
             end
  end

  def destroy
    @user.destroy
    redirect_to home_path, notice: 'User succesfully deleted'
  end

  def toggle
    @user.update(enabled: !@user.enabled)
    redirect_to home_path
  end

  def find_user
    @user = User.find(params[:id])
    authorize @user
  end

  def redirect_guest
    redirect_to root_path unless user_signed_in?
  end

  def home_path
    return admin_user_path(current_user) if current_user.admin?
    return user_path(current_user) if current_user.user?
    return manager_user_path(current_user) if current_user.manager?
  end

  private

  def user_permit_params
    params.require(:user).permit(:email, :name, :password, :role, :image)
  end
end
