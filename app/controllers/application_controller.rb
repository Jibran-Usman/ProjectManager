# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  include Pundit

  rescue_from Pundit::NotAuthorizedError do |_exception|
    flash[:alert] = 'You can not access this namespace or action'
    redirect_to user_path(current_user) if current_user.user?
    redirect_to admin_user_path(current_user) if current_user.admin?
    redirect_to manager_user_path(current_user) if current_user.manager?
  end

  def after_sign_out_path_for(_resource_or_scope)
    root_path
  end

  def after_sign_in_path_for(_resource_or_scope)
    if current_user.admin?
      admin_user_path(current_user)
    elsif current_user.manager?
      manager_user_path(current_user)
    else
      user_path(current_user)
    end
  end

  protected

  def configure_permitted_parameters
    permitted_params = %i[name password enabled image role email]
    devise_parameter_sanitizer.permit(:account_update, keys: permitted_params)
    devise_parameter_sanitizer.permit(:sign_up, keys: permitted_params)
  end
end
