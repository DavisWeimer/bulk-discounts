class BulkDiscount < ApplicationRecord
  validates :discount_percentage, numericality: { greater_than_or_equal_to: 0.01, less_than_or_equal_to: 0.99 }
  validates_presence_of :minimum_quantity

  belongs_to :merchant
  has_many :item_bulk_discounts, dependent: :destroy
  has_many :items, through: :item_bulk_discounts, dependent: :destroy

  def percentage_converted
    (discount_percentage * 100).to_i
  end
end