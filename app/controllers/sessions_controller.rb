class SessionsController < ApplicationController
  def new
    @user = User.new
    render "dangnhap"
  end

  def create
    user = User.find_by(email: params[:email])

    if user
      # Kiểm tra tài khoản đã bị khóa chưa
      if user.isclock.to_i.zero?
        flash.now[:danger] = "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ admin."
        render "dangnhap" and return
      end

      # Kiểm tra mật khẩu
      if user.password_pidget == params[:password_pidget]
        # Kiểm tra lại một lần nữa trước khi cho đăng nhập
        if user.isclock.to_i.zero?
          flash.now[:danger] = "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ admin."
          render "dangnhap" and return
        end

        log_in user
        if user.loai_quyen == "admin"
          redirect_to index3_path
        else
          redirect_to index2_path
        end
      else
        # Tăng số lần đăng nhập thất bại
        current_attempts = user.solandnthatbai.to_i + 1

        # Cập nhật số lần thất bại và khóa tài khoản nếu cần
        if current_attempts >= 5
          if user.update(solandnthatbai: current_attempts, isclock: 0)
            flash.now[:danger] = "Tài khoản đã bị khóa do đăng nhập sai nhiều lần."
          end
        else
          if user.update(solandnthatbai: current_attempts)
            flash.now[:danger] = "Mật khẩu không chính xác. Còn #{5 - current_attempts} lần thử."
          end
        end

        render "dangnhap"
      end
    else
      flash.now[:danger] = "Tên đăng nhập không tồn tại."
      render "dangnhap"
    end
  end

  def destroy
    session[:user_id] = nil  # Xóa session
    redirect_to login_path, notice: "Đăng xuất thành công." and return
  end

  private

  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
