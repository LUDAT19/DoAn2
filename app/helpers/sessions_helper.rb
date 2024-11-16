module SessionsHelper
  # Đăng nhập người dùng
  def log_in(user)
    session[:user_id] = user.id
  end

  # Kiểm tra xem người dùng đã đăng nhập chưa
  def logged_in?
    !session[:user_id].nil?
  end

  # Đăng xuất
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  # Lấy người dùng hiện tại
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
