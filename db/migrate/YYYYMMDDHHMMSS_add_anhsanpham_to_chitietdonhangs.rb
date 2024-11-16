class AddAnhsanphamToChitietdonhangs < ActiveRecord::Migration[7.0]
  def change
    add_column :chitietdonhangs, :anhsanpham, :string
  end
end
