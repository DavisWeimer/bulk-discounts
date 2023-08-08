require "rails_helper"

RSpec.describe "bulk discounts dashboard", type: :feature do
  describe "User Story 2" do
    before do
=begin

Welp, I tried. It keeps trying to actually make the HTTP request?
I'm thinking it's something to do with HTTParty configuration?
The lesson uses Faraday and I tried that for a second but switched back
I'll keep looking into it!

      WebMock.enable!

      body = [
        {
          "date": "2023-12-25",
          "localName": "Christmas Day"
        },
        {
          "date": "2023-11-11",
          "localName": "Veterans Day"
        },
        {
          "date": "2023-10-31",
          "localName": "Halloween"
        }
      ].to_json

      stub_request(:get, "https://date.nager.at/api/v3/NextPublicHolidays/US").
        with(
          headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby'
          }).
        to_return(status: 200, body: body, headers: {})
    
      registered request stubs:
        
      stub_request(:get, "https://date.nager.at/api/v3/NextPublicHolidays/US").
        with(
          headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'HTTParty'
          })

      @upcoming_holidays = HolidayService.new.upcoming_holidays

=end
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

      @upcoming_holidays = HolidayService.new.upcoming_holidays
    end

    it "displays a section with the 3 upcoming US holidays from the Nager.Date API" do
      visit merchant_bulk_discounts_path(@merchant_A.id)
      expect(page).to have_content("Upcoming Holidays")

      within "#upcoming_holidays" do
        expect(@upcoming_holidays.count).to eq(3)
      end
    end
  end
end