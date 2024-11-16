class CreateChitietdonhang < ActiveRecord::Migration[7.0]
  def change
    create_table :chitietdonhang do |t|
      t.references :donhang, null: false, foreign_key: { to_table: :donhang }
      t.string :tensanpham, null: false
      t.string :anhsanpham
      t.integer :soluong, null: false
      t.decimal :dongia, precision: 10, scale: 2, null: false
      t.decimal :thanhtien, precision: 10, scale: 2, null: false
      t.timestamp :thoigiantao, default: -> { 'CURRENT_TIMESTAMP' }
      t.timestamp :thoigiancapnhat, default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end 