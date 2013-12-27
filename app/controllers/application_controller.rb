class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
	before_filter :fetch_logged_in_user

	protected
	def fetch_logged_in_user
		return if session[:user_id].blank?
		@current_user = User.find_by_id(session[:user_id])
		logger.info "#{@current_user.login} requested #{request.fullpath} on #{Time.now}"
	end

	def logged_in?
		!@current_user.blank?
	end
	helper_method :logged_in?

  def login_required
	  return true if logged_in?
	  session[:return_to] = request.fullpath
	  redirect_to controller: 'account', action: 'login' and return false
  end

end
