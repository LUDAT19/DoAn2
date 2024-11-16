class AddIdDmToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :id_dm, :integer
    add_foreign_key :products, :danhmucsanphams, column: :id_dm
    add_index :products, :id_dm
  end
end 