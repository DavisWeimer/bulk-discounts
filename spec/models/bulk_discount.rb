require "rails_helper"

RSpec.describe BulkDiscount, type: :model do
  describe "validations" do
    it { should validate_presence_of :discount_percentage }
    it { should validate_presence_of :minimum_quantity }
  end
  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :item_bulk_discounts }
    it { should have_many(:items).through(:item_bulk_discounts) }
  end

  describe "instance methods" do
    it "#percentage_converted" do
      merchant_A = create(:merchant)
      bulk_discount_A = create(:bulk_discount, merchant: merchant_A, discount_percentage: 0.34)
      bulk_discount_B = create(:bulk_discount, merchant: merchant_A, discount_percentage: 0.99)

      expect(bulk_discount_A.percentage_converted).to eq(34)
      expect(bulk_discount_B.percentage_converted).to eq(99)
    end
  end
end