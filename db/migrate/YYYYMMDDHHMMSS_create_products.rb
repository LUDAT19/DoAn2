class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products, id: :uuid do |t|
      t.string :name
      t.text :mota
      t.decimal :price, precision: 10, scale: 2
      t.string :image_path
      t.references :danhmucsanpham, foreign_key: true, column: :id_dm

      t.timestamps
    end
  end
end 