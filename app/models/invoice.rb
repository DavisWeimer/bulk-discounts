class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items, dependent: :destroy
  has_many :merchants, through: :items, dependent: :destroy
  has_many :item_bulk_discounts, through: :items, dependent: :destroy
  has_many :bulk_discounts, through: :item_bulk_discounts, dependent: :destroy

  enum status: [:cancelled, :in_progress, :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def discounted_revenue
    total_discounted_revenue = 0
  
    invoice_items.each do |invoice_item|
      bulk_discount = invoice_item.item.applicable_bulk_discount(invoice_item.quantity)
  
      if bulk_discount
        discounted_price = (invoice_item.unit_price - (invoice_item.unit_price * bulk_discount.discount_percentage)).round(2)
        total_discounted_revenue += discounted_price * invoice_item.quantity
      else
        total_discounted_revenue += invoice_item.total_price
      end
    end
  
    total_discounted_revenue
  end

=begin
I could not get this same functionality in the AR query yet, 
I'll return to this later during some refactoring

def discounted_revenue
  total_discounted_revenue = invoice_items
    .joins(item: { item_bulk_discounts: :bulk_discount })
    .where("bulk_discounts.minimum_quantity <= invoice_items.quantity")
    .order(discount_percentage: :desc)
    .first
end
=end
end 
