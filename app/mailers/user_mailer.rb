class UserMailer < ApplicationMailer
  def password_reset(user)
    @user = user
    mail(to: @user.email, subject: "Đặt Lại Mật Khẩu")
  end
end
