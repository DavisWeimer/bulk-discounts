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
      merchantA = create(:merchant)
      bulk_discount_A = create(:bulk_discount, merchant: merchantA, discount_percentage: 20, minimum_quantity: 10)
    end
  end
end