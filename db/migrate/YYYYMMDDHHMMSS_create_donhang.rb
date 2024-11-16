class CreateDonhang < ActiveRecord::Migration[7.0]
  def change
    create_table :donhang do |t|
      t.decimal :tongtien, precision: 10, scale: 2, null: false
      t.string :trangthaidonhang, default: 'chưa duyệt'
      t.timestamp :thoigiantao, default: -> { 'CURRENT_TIMESTAMP' }
      t.timestamp :thoigiancapnhat, default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end 