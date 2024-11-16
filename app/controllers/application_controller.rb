class ApplicationController < ActionController::Base
  include SessionsHelper

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :no_cache

  # Thêm helper method để kiểm tra user đã đăng nhập chưa
  helper_method :current_user, :user_signed_in?

  private

  def no_cache
    response.headers["Cache-Control"] = "no-store, no-cache, max-age=0, must-revalidate, private"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def check_user_login
    unless session[:user_id]
      flash[:alert] = "Vui lòng đăng nhập để tiếp tục!"
      redirect_to login_path # Hoặc đường dẫn tới trang đăng nhập của bạn
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def user_signed_in?
    current_user.present?
  end
end
