class Chitietdonhang < ApplicationRecord
  self.table_name = "chitietdonhang"

  belongs_to :donhang

  validates :tensanpham, :soluong, :dongia, :thanhtien, :sdt_nn, :diachi_nn, :anhsanpham, presence: true
end
