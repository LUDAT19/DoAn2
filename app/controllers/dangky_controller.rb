class DangkyController < ApplicationController
  def index
    # Hiển thị trang đăng ký (nếu bạn muốn)
    @user = User.new
    render "sessions/dangky"
  end

  def new
    # Hiển thị trang đăng ký
    @user = User.new
  end

  def create
    # Xử lý đăng ký người dùng
    @user = User.new(user_params)
    if @user.save
      # Nếu lưu thành công, chuyển hướng đến trang khác, ví dụ: trang chủ
      redirect_to root_path, notice: "Đăng ký thành công!"
    else
      # Nếu lưu thất bại, hiển thị lại trang đăng ký với các thông báo lỗi
      render "sessions/dangky"
    end
  end

  # private
  # Phương thức mạnh mẽ để chỉ cho phép các tham số cần thiết
  # def user_params
  #   params.require(:user).permit(:username, :password_pidget)
  # end
  private
  def user_params
    params.require(:nguoidung).permit(:username, :sdt, :email, :password_pidget, :diachi, :loai_quyen)
  end
end
