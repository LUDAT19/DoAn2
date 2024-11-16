class AddAnhsanphamToChitietdonhangs < ActiveRecord::Migration[7.0]
  def change
    add_column :chitietdonhang, :anhsanpham, :string
  end
end
