class CreateChitietdonhangs < ActiveRecord::Migration[7.0]
  def change
    create_table :chitietdonhangs do |t|
      t.references :donhang, null: false, foreign_key: { to_table: :donhangs }
      t.string :tensanpham, null: false
      t.string :anhsanpham
      t.integer :soluong, null: false
      t.decimal :dongia, precision: 10, scale: 2, null: false
      t.decimal :thanhtien, precision: 10, scale: 2, null: false
      t.timestamps
    end
  end
end 