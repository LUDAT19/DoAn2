class Danhmucsanpham < ApplicationRecord
  has_many :products, foreign_key: 'id_dm', dependent: :destroy
  validates :ten_danhmuc, presence: true, uniqueness: { message: "đã tồn tại trong hệ thống" }
end 