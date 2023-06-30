class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
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
end
