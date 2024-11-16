class PasswordResetsController < ApplicationController
  def new
    # Hiển thị form yêu cầu đặt lại mật khẩu
  end

  def create
    user = User.find_by(email: params[:email])

    if user
      user.initiate_password_reset
      flash[:notice] = "Email hướng dẫn đặt lại mật khẩu đã được gửi. Vui lòng kiểm tra email của bạn."
      redirect_to login_path
    else
      flash.now[:alert] = "Email không tồn tại trong hệ thống"
      render :new
    end
  end

  def edit
    @user = User.find_by(password_reset_token: params[:token])
    if @user.nil? || @user.password_reset_sent_at < 1.minute.ago
      redirect_to new_password_reset_path, alert: "Mã xác nhận không hợp lệ."
    end
  end

  def update
    @user = User.find_by(password_reset_token: params[:token])

    # Kiểm tra nếu không tìm thấy người dùng
    if @user.nil? || @user.password_reset_sent_at < 1.minute.ago
      flash.now[:alert] = "Liên kết đặt lại mật khẩu không hợp lệ hoặc đã hết hạn."
      render :edit
      return
    end

    # Kiểm tra nếu mật khẩu và mật khẩu xác nhận không khớp
    if params[:password] != params[:password_confirmation]
      flash.now[:alert] = "Mật khẩu xác nhận không khớp."
      render :edit
      return
    end

    # Thử cập nhật mật khẩu
    if @user.update(password_pidget: params[:password])
      redirect_to login_path, notice: "Mật khẩu đã được thay đổi thành công."
    else
      # Hiển thị các lỗi nếu quá trình cập nhật không thành công
      flash.now[:alert] = @user.errors.full_messages.join(", ")
      render :edit
    end
  end
end
