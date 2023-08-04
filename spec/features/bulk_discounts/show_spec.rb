require "rails_helper"

RSpec.describe "bulk discounts show", type: :feature do
  describe "User Story 4" do
    before :each do
      @merchant_A = create(:merchant)
      @bulk_discounts = create_list(:bulk_discount, 5, merchant: @merchant_A)
    end
    
    it "displays specific bulk discount attributes" do
      bulk_discount_A = create(:bulk_discount, merchant: @merchant_A, discount_percentage: 0.40, minimum_quantity: 1163)
      
      visit merchant_bulk_discount_path(@merchant_A, bulk_discount_A)

      expect(page).to have_content("-#{bulk_discount_A.percentage_converted}% off")
      expect(page).to have_content(bulk_discount_A.minimum_quantity)

    end
  end
end