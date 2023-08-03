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
end