require "rails_helper"

describe "Admin Invoices Index Page" do
  before :each do
    @m1 = Merchant.create!(name: "Merchant 1")

    @c1 = Customer.create!(first_name: "Yo", last_name: "Yoz", address: "123 Heyyo", city: "Whoville", state: "CO", zip: 12345)
    @c2 = Customer.create!(first_name: "Hey", last_name: "Heyz")

    @i1 = Invoice.create!(customer_id: @c1.id, status: 2, created_at: "2012-03-25 09:54:09")
    @i2 = Invoice.create!(customer_id: @c2.id, status: 1, created_at: "2012-03-25 09:30:09")

    @item_1 = Item.create!(name: "test", description: "lalala", unit_price: 6, merchant_id: @m1.id)
    @item_2 = Item.create!(name: "rest", description: "dont test me", unit_price: 12, merchant_id: @m1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_1.id, quantity: 12, unit_price: 2, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_2.id, quantity: 6, unit_price: 1, status: 1)
    @ii_3 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_2.id, quantity: 87, unit_price: 12, status: 2)

  end
  
  it "should display the id, status and created_at" do
    visit admin_invoice_path(@i1)
    expect(page).to have_content("Invoice ##{@i1.id}")
    expect(page).to have_content("Created on: #{@i1.created_at.strftime("%A, %B %d, %Y")}")
    
    expect(page).to_not have_content("Invoice ##{@i2.id}")
  end
  
  it "should display the customers name and shipping address" do
    visit admin_invoice_path(@i1)
    expect(page).to have_content("#{@c1.first_name} #{@c1.last_name}")
    expect(page).to have_content(@c1.address)
    expect(page).to have_content("#{@c1.city}, #{@c1.state} #{@c1.zip}")
    
    expect(page).to_not have_content("#{@c2.first_name} #{@c2.last_name}")
  end
  
  it "should display all the items on the invoice" do
    visit admin_invoice_path(@i1)
    expect(page).to have_content(@item_1.name)
    expect(page).to have_content(@item_2.name)
    
    expect(page).to have_content(@ii_1.quantity)
    expect(page).to have_content(@ii_2.quantity)
    
    expect(page).to have_content("$#{@ii_1.unit_price}")
    expect(page).to have_content("$#{@ii_2.unit_price}")
    
    expect(page).to have_content(@ii_1.status)
    expect(page).to have_content(@ii_2.status)
    
    expect(page).to_not have_content(@ii_3.quantity)
    expect(page).to_not have_content("$#{@ii_3.unit_price}")
    expect(page).to_not have_content(@ii_3.status)
  end
  
  it "should display the total revenue the invoice will generate" do
    visit admin_invoice_path(@i1)
    expect(page).to have_content("Total Revenue: $#{@i1.total_revenue}")
    
    expect(page).to_not have_content(@i2.total_revenue)
  end
  
  it "should have status as a select field that updates the invoices status" do
    visit admin_invoice_path(@i1)
    within("#status-update-#{@i1.id}") do
      select("cancelled", :from => "invoice[status]")
      expect(page).to have_button("Update Invoice")
      click_button "Update Invoice"

      expect(current_path).to eq(admin_invoice_path(@i1))
      expect(@i1.status).to eq("completed")
    end
  end

  describe "User Story 8" do
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

    it "displays the total discounted revenue for this admin invoice" do
      visit admin_invoice_path(@invoice_A)
      save_and_open_page
      expect(page).to have_content("Total Revenue: $17,500.00") 
      expect(page).to have_content("Discounted Revenue: $5,425.00")
    end
  end
end
