class Donhang < ApplicationRecord
  self.table_name = "donhang"

  belongs_to :user, foreign_key: "id_kh"
  belongs_to :product, foreign_key: "id_sp"
  has_many :chitietdonhang, foreign_key: "donhang_id", dependent: :destroy

  validates :tongtien, :phuongthucthanhtoan, :trangthaidonhang, presence: true
end
