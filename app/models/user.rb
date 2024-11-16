class User < ApplicationRecord
  # Định nghĩa các hằng số
  QUYEN_TYPES = [ "admin", "staff", "customer" ].freeze
  MAX_LOGIN_ATTEMPTS = 5

  PASSWORD_FORMAT = /\A
    (?=.*[A-Z])           # Phải có ít nhất 1 chữ in hoa
    (?=.*[!@#$%^&*])      # Phải có ít nhất 1 ký tự đặc biệt
    (?=.{8,})             # Phải có ít nhất 8 ký tự
  /x

  # Các validation
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password_pidget, presence: true,
            format: { with: PASSWORD_FORMAT, message: "phải có ít nhất 8 ký tự, 1 chữ in hoa và 1 ký tự đặc biệt" },
            if: -> { new_record? || password_pidget.present? }
  validates :sdt, presence: true,
            format: { with: /\A\d{10,11}\z/, message: "phải có 10-11 số" }
  validates :diachi, presence: true
  validates :loai_quyen, presence: true, inclusion: { in: QUYEN_TYPES }

  # Callbacks
  before_save :check_login_attempts, :log_changes
  after_initialize :set_default_values, if: :new_record?
  after_save :ensure_status_consistency

  # Thêm từ khóa public để đảm bảo method có thể được gọi từ bên ngoài
  public

  def initiate_password_reset
    generate_password_reset_token
    self.password_reset_sent_at = Time.zone.now
    save!(validate: false)
    UserMailer.password_reset(self).deliver_now
  end

  private

  def generate_password_reset_token
    self.password_reset_token = SecureRandom.urlsafe_base64
  end

  def check_login_attempts
    if solandnthatbai.to_i >= 5
      self.isclock = 0
    end
  end

  def set_default_values
    self.solandnthatbai ||= 0
    self.isclock = 1 if self.isclock.nil?
    self.loai_quyen ||= "customer"
  end

  def log_changes
    Rails.logger.debug "Before save - isclock changing from #{isclock_was} to #{isclock}"
  end

  def ensure_status_consistency
    if solandnthatbai.to_i >= 5 && isclock != 0
      update_column(:isclock, 0)
    end
  end
end
