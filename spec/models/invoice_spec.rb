require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions}
    it { should have_many(:item_bulk_discounts).through(:items) }
    it { should have_many(:bulk_discounts).through(:item_bulk_discounts) }
  end
  describe "instance methods" do
    it "total_revenue" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

      expect(@invoice_1.total_revenue).to eq(100)
    end

    it "#discounted_revenue" do
      @merchant_A = create(:merchant)
  
      @bulk_discount_A = create(:bulk_discount, merchant: @merchant_A, discount_percentage: 0.25, minimum_quantity: 5)
      @bulk_discount_B = create(:bulk_discount, merchant: @merchant_A, discount_percentage: 0.68, minimum_quantity: 15)
      
      @item_A = create(:item, merchant: @merchant_A, unit_price: 15)
      
      @item_B = create(:item, merchant: @merchant_A, unit_price: 5)
      
      @customer = create(:customer)
      @invoice_A = create(:invoice, customer: @customer, status: :completed)
      
      @invoice_item_1 = create(:invoice_item, invoice: @invoice_A, item: @item_A, quantity: 15, unit_price: @item_A.unit_price, status: :shipped)
      @invoice_item_2 = create(:invoice_item, invoice: @invoice_A, item: @item_B, quantity: 14, unit_price: @item_B.unit_price, status: :shipped)

      @merchant_A.associate_bulk_discounts
      
      expect(@invoice_A.total_revenue).to eq(295)
      expect(@invoice_A.discounted_revenue).to eq(124.5)
    end
  end
end
