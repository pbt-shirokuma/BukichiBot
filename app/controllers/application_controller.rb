class ApplicationController < ActionController::Base
  before_action :current_user
  before_action :require_sign_in!
  
  def current_user
    @current_user = User.find_by(id: session[:user_id])
  end
  
  def signed_in?
    @current_user.present?
  end
  
  def require_sign_in!
    redirect_to new_session_path unless signed_in?
  end
  
end
