class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :payment_method
      t.string :receiver_phone
      t.string :receiver_address
      t.decimal :total_amount, precision: 10, scale: 2
      t.string :status
      t.json :card_info

      t.timestamps
    end
  end
end
