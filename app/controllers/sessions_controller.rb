class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user && (user.authenticate params[:session][:password])
      check_activated user
    else
      flash.now[:danger] = t ".invalid_email_password"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def check_remember user
    params[:session][:remember_me] == Settings.sessions_controller.remember_me ? remember(user) : forget(user)
  end

  def check_activated user
    if user.activated?
      log_in user
      check_remember user
      redirect_back_or user
    else
      message  = t ".account_not_activated"
      message += t ".check_email"
      flash[:warning] = message
      redirect_to root_url
    end
  end
end
