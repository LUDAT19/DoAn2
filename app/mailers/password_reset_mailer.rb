class PasswordResetMailer < ApplicationMailer
  def password_reset
    @user = params[:user]
    mail(to: @user.email, subject: "Đặt lại mật khẩu")
  end
end
