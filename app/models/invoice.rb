class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items, dependent: :destroy
  has_many :merchants, through: :items, dependent: :destroy
  has_many :bulk_discounts, through: :item_bulk_discounts, dependent: :destroy

  enum status: [:cancelled, :in_progress, :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def discounted_revenue
    invoice_items.sum do |invoice_item|
      item = invoice_item.item
      bulk_discount = item.applicable_bulk_discount(invoice_item.quantity)
      if bulk_discount
        (invoice_item.unit_price - (invoice_item.unit_price * bulk_discount.discount_percentage)).round(2) * invoice_item.quantity
      else
        invoice_item.total_price
      end
    end
  end
end 
