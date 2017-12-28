class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to(root_url) unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t ".please_log_in"
    redirect_to login_url
  end
end
