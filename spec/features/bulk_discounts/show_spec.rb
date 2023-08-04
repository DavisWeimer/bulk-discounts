require "rails_helper"

RSpec.describe "bulk discounts show", type: :feature do
  describe "User Story 4" do
    before :each do
      @merchant_A = create(:merchant)
      @bulk_discounts = create_list(:bulk_discount, 5, merchant: @merchant_A)
    end
    
    it "displays specific bulk discount attributes" do
      bulk_discounts_to_show = @bulk_discounts[0..2]

      visit merchant_bulk_discounts_path(@merchant_A)

      bulk_discounts_to_show.each do |discount|
        within "#discount-#{discount.id}" do
          click_button("Show Page")
          expect(current_path).to eq(merchant_bulk_discount_path(@merchant_A, discount))
          expect(page).to have_content("-#{discount.percentage_converted}% off")
          expect(page).to have_content(discount.minimum_quantity)
          save_and_open_page
        end
      end
    end
  end
end