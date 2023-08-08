require "rails_helper"

RSpec.describe "bulk discounts dashboard", type: :feature do
  describe "User Story 2" do
    before :each do
      @merchant_A = create(:merchant)
      @bulk_discounts = create_list(:bulk_discount, 5, merchant: @merchant_A)
    end

    it "displays a link to create new discount" do

      visit merchant_bulk_discounts_path(@merchant_A.id)

      expect(page).to have_link("Create New Discount", href: new_merchant_bulk_discount_path(@merchant_A))
    end

    it "can create new discount and redirects back to bulk discount index" do

      visit new_merchant_bulk_discount_path(@merchant_A)
      fill_in "bulk_discount[discount_percentage]", with: 0.77
      fill_in "bulk_discount[minimum_quantity]", with: 13
      click_button

      expect(page).to have_content(77)
      expect(page).to have_content(13)
    end

    it "cannot be submitted with invalid data" do

      visit new_merchant_bulk_discount_path(@merchant_A)
      fill_in "bulk_discount[discount_percentage]", with: 112.77325
      fill_in "bulk_discount[minimum_quantity]", with: 13
      click_button
      
      expect(page).to have_content("Discount percentage must be between 0.01 and 0.99")

    end
  end

  describe "User Story 3" do
    before :each do
      @merchant_A = create(:merchant)
      @bulk_discounts = create_list(:bulk_discount, 5, merchant: @merchant_A)
    end

    it "displays a link to delete the discount" do

      visit merchant_bulk_discounts_path(@merchant_A.id)

      expect(page).to have_button("Delete")
    end

    it "can delete discount and redirects back to bulk discount index" do
      discounts_to_delete = @bulk_discounts[0..1]

      visit merchant_bulk_discounts_path(@merchant_A.id)
      
      discounts_to_delete.each do |discount|
        within "#discount-#{discount.id}" do
          click_button "Delete"
          expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_A))
        end
      end

      discounts_to_delete.each do |discount|
        expect(page).to_not have_field(:discount_percentage, with: discount.discount_percentage)
        expect(page).to_not have_field(:minimum_quantity, with: discount.minimum_quantity)
      end
    end
  end

  describe "User Story 9" do
    before :each do
      @merchant_A = create(:merchant)
  
      @bulk_discount_A = create(:bulk_discount, merchant: @merchant_A, discount_percentage: 0.69, minimum_quantity: 420)
      
      @item_A = create(:item, merchant: @merchant_A, unit_price: 15)
      
      @item_B = create(:item, merchant: @merchant_A, unit_price: 5)
      
      @customer = create(:customer)
      @invoice_A = create(:invoice, customer: @customer, status: :completed)
      
      @invoice_item_1 = create(:invoice_item, invoice: @invoice_A, item: @item_A, quantity: 1000, unit_price: @item_A.unit_price, status: :shipped)
      @invoice_item_2 = create(:invoice_item, invoice: @invoice_A, item: @item_B, quantity: 500, unit_price: @item_B.unit_price, status: :shipped)
      
      @merchant_A.associate_bulk_discounts
    end

    it "displays a section with the 3 upcoming US holidays from the Nager.Date API" do
      visit merchant_bulk_discounts_path(@merchant_A.id)
      expect(page).to have_content("Upcoming Holidays")
    end
  end
end