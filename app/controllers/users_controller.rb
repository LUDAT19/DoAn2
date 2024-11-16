class UsersController < ApplicationController
  before_action :require_login

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: 'Tạo tài khoản thành công.'
    else
      render :new
    end
  end

  def update
    @user = User.find(params[:id])
    
    update_params = user_params
    if update_params[:password_pidget].blank?
      update_params = update_params.except(:password_pidget)
    end
    
    # Reset số lần đăng nhập thất bại khi admin mở khóa tài khoản
    if update_params[:isclock].to_i == 1
      update_params[:solandnthatbai] = 0
    end
    
    if @user.update(update_params)
      redirect_to users_path, notice: 'Cập nhật tài khoản thành công.'
    else
      redirect_to users_path, alert: 'Cập nhật không thành công.'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, notice: 'Xóa tài khoản thành công.'
  end

  def profile
    @user = current_user
  end

  def edit_profile
    @user = current_user
  end

  def update_profile
    @user = current_user
    if @user.update(user_params)
      redirect_to user_profile_path, notice: 'Cập nhật thông tin thành công!'
    else
      render :edit_profile, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :username, 
      :email, 
      :password_pidget, 
      :sdt, 
      :diachi, 
      :loai_quyen, 
      :solandnthatbai, 
      :isclock
    )
  end

  def require_login
    unless logged_in?
      flash[:error] = "Bạn cần đăng nhập để truy cập trang này!"
      redirect_to dangnhap_path
    end
  end
end 
