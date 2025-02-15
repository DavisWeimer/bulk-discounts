class Item < ApplicationRecord
  validates_presence_of :name,
                        :description,
                        :unit_price,
                        :merchant_id

  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items, dependent: :destroy
  belongs_to :merchant
  has_many :item_bulk_discounts, dependent: :destroy
  has_many :bulk_discounts, through: :item_bulk_discounts, dependent: :destroy

  enum status: [:disabled, :enabled]

  def best_day
    invoices
    .joins(:invoice_items)
    .where('invoices.status = 2')
    .select('invoices.*, sum(invoice_items.unit_price * invoice_items.quantity) as money')
    .group(:id)
    .order("money desc", "created_at desc")
    .first&.created_at&.to_date
  end

  def applicable_bulk_discount(quantity)
    bulk_discounts.where("minimum_quantity <= ?", quantity).order(discount_percentage: :desc).first
  end
end
