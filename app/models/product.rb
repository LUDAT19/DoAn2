class Product < ApplicationRecord
  belongs_to :danhmucsanpham, foreign_key: 'id_dm'
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :id_dm, presence: true

  before_create :set_next_id

  private

  def set_next_id
    last_id = Product.maximum(:id) || 0
    self.id = last_id + 1
  end
end
