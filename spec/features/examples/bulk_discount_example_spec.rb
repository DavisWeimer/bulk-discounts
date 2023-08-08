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
      bulk_discount_A = create(:bulk_discount, merchant: merchant_A, discount_percentage: 0.20, minimum_quantity: 10)
      item_A = create(:item, merchant: merchant_A)
      item_B = create(:item, merchant: merchant_A)

      customer = create(:customer)
      customers = create_list(:customer, 40)
      invoice_A = create(:invoice, customer: customer, status: :completed)
      
      invoice_item_1 = create(:invoice_item, invoice: invoice_A, item: item_A, quantity: 5, status: :shipped)
      invoice_item_2 = create(:invoice_item, invoice: invoice_A, item: item_B, quantity: 5, status: :shipped)

      transaction_1 = create(:transaction, invoice: invoice_A, result: :success)

      eligible_discounts = invoice_A.merchants.first.bulk_discounts.where("minimum_quantity <= ?", invoice_A.items.sum(:quantity))
      total_price_without_discount = invoice_item_1.total_price + invoice_item_2.total_price

      expect(invoice_A.total_revenue).to eq(total_price_without_discount)
    end
  end

  describe "can generate" do
    xit "a customer CSV from FactoryBot!" do
      customers = FactoryBot.build_list(:customer, 1000)
      
      csv_headers = ["first_name", "last_name"]

      csv_data = CSV.generate(headers: true) do |csv|
        csv << csv_headers

        customers.each do |customer|
          csv << [customer.first_name, customer.last_name]
        end
      end

      File.write("customers_gen.csv", csv_data)
    end

    xit "a merchant CSV from FactoryBot!" do
      merchants = FactoryBot.build_list(:merchant, 100)
      
      csv_headers = ["name"]

      csv_data = CSV.generate(headers: true) do |csv|
        csv << csv_headers

        merchants.each do |merchant|
          csv << [merchant.name]
        end
      end

      File.write("merchants_gen.csv", csv_data)
    end

    xit "an item CSV from FactoryBot!" do
      items = FactoryBot.build_list(:item, 2500)

      csv_headers = ["name", "description", "unit_price"]

      csv_data = CSV.generate(headers: true) do |csv|
        csv << csv_headers

        items.each do |item|
          csv << [item.name, item.description, item.unit_price]
        end
      end

      File.write("items_gen.csv", csv_data)
    end
  end
end