class CreateDonhangs < ActiveRecord::Migration[7.0]
  def change
    create_table :donhangs do |t|
      t.decimal :tongtien, precision: 10, scale: 2, null: false
      t.string :trangthaidonhang, default: 'chưa duyệt'
      t.timestamps
    end
  end
end
