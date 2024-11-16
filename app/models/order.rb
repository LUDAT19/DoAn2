class Order < ApplicationRecord
  belongs_to :user
  has_many :order_details, dependent: :destroy

  validates :receiver_phone, :receiver_address, :payment_method, presence: true
  validates :total_amount, presence: true, numericality: { greater_than: 0 }

  # Thêm các validations khác nếu cần
end
