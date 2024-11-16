class AuthenticationService
  def self.handle_failed_login(user)
    return unless user
    
    new_attempts = (user.solandnthatbai || 0) + 1
    user.update(
      solandnthatbai: new_attempts,
      isclock: new_attempts >= 5 ? 0 : user.isclock
    )
  end

  def self.reset_failed_attempts(user)
    user.update(solandnthatbai: 0) if user
  end
end 