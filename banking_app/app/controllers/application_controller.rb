class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  helper_method :current_user, :logged_in?, :current_account
  def current_user
    @current_user = User.find_by(customer_id:session[:user_id]) if session[:user_id]
  end
  def logged_in?
      !!current_user
  end
  def current_account
    @current_account = Account.find_by(account_number: session[:account_number]) if session[:account_number]
  end
  def require_user
    if !logged_in?
      flash[:alert] = "You must be logged in to perform this action"
      redirect_to login_path
    end
  end
  def record_not_found
    flash[:alert] = "Requested details not found for user"
    redirect_to current_user
  end
  def require_account
    if !(!!current_account)
      flash[:alert] = "No account found to perform this action"
      redirect_to current_user
    end
  end
end
