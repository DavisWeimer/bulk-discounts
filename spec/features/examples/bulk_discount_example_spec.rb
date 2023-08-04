require "rails_helper"

=begin
  On top of drawing these examples out on paper
  I think it will prove very useful to code them out
  as tests where I can experiment with FactoryBot and 
  get a better grip on the concept
=end


RSpec.describe "Bulk Discount Examples" do
  describe "#example 1" do
    it "tests that Merchant A's discount will not apply" do
      merchant_A = create(:merchant)
      bulk_discount_A = create(:bulk_discount, merchant: merchant_A, discount_percentage: 20, minimum_quantity: 10)
      item_A = create(:item, merchant: merchant_A)
      item_B = create(:item, merchant: merchant_A)

      customer = create(:customer)
      invoice_A = create(:invoice, customer: customer, status: :completed)
      
      invoice_item_1 = create(:invoice_item, invoice: invoice_A, item: item_A, quantity: 5, status: :shipped)
      invoice_item_2 = create(:invoice_item, invoice: invoice_A, item: item_B, quantity: 5, status: :shipped)
      # require 'pry'; binding.pry
      total_price_without_discount = invoice_item_1.total_price + invoice_item_2.total_price
    end
  end
end