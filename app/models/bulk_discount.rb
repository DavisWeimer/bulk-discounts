class BulkDiscount < ApplicationRecord
  validates_presence_of :discount_percentage,
                        :minimum_quantity
  belongs_to :merchant
  has_many :item_bulk_discounts, dependent: :destroy
  has_many :items, through: :item_bulk_discounts, dependent: :destroy
end