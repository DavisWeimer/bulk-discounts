# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Customer.destroy_all
Merchant.destroy_all
Item.destroy_all
Invoice.destroy_all
Transaction.destroy_all
InvoiceItem.destroy_all

Rake::Task["csv_load:all"].invoke

Merchant.all.each do |merchant|
  merchant.associate_bulk_discounts
end
puts "——————————————————————————"
puts "Bulk discounts associated."

# # 25.times do
# #   merchant = FactoryBot.create(:merchant)
# #   merchant_2 = FactoryBot.create(:merchant)

# #   bulk_discount_A = FactoryBot.create(:bulk_discount, merchant: merchant)
# #   bulk_discount_B = FactoryBot.create(:bulk_discount, merchant: merchant)

# #   item_A = FactoryBot.create(:item, merchant: merchant)
# #   item_A.bulk_discounts.push(bulk_discount_A)

# #   item_B = FactoryBot.create(:item, merchant: merchant)
# #   item_B.bulk_discounts.push(bulk_discount_B)

# #   item_C = FactoryBot.create(:item, merchant: merchant_2)
# #   # item_C.bulk_discounts.push(bulk_discount_B)

# #   item_D = FactoryBot.create(:item, merchant: merchant_2)
# #   # item_B.bulk_discounts.push(bulk_discount_B)

# #   customer = FactoryBot.create(:customer)
# #   invoice_1 = FactoryBot.create(:invoice, customer: customer)
# #   invoice_2 = FactoryBot.create(:invoice, customer: customer)

# #   invoice_item_1 = FactoryBot.create(:invoice_item, invoice: invoice_1, item: item_A, quantity: bulk_discount_A.minimum_quantity)
# #   invoice_item_2 = FactoryBot.create(:invoice_item, invoice: invoice_1, item: item_A, quantity: bulk_discount_A.minimum_quantity)
# #   invoice_item_3 = FactoryBot.create(:invoice_item, invoice: invoice_1, item: item_C, quantity: bulk_discount_A.minimum_quantity)
# #   invoice_item_4 = FactoryBot.create(:invoice_item, invoice: invoice_2, item: item_A, quantity: bulk_discount_B.minimum_quantity)
# #   invoice_item_5 = FactoryBot.create(:invoice_item, invoice: invoice_2, item: item_B, quantity: bulk_discount_B.minimum_quantity)
# #   invoice_item_6 = FactoryBot.create(:invoice_item, invoice: invoice_2, item: item_D, quantity: bulk_discount_B.minimum_quantity)
# #   invoice_item_7 = FactoryBot.create(:invoice_item, invoice: invoice_2, item: item_C, quantity: bulk_discount_B.minimum_quantity)

#   transaction_1 = FactoryBot.create(:transaction, invoice: invoice_1)
#   transaction_2 = FactoryBot.create(:transaction, invoice: invoice_2)
# end