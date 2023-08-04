class BulkDiscountsController < ApplicationController
  before_action :find_merchant, only: [:new, :create, :index]

  def index
    @bulk_discounts = @merchant.bulk_discounts
  end

  def new
    @bulk_discount = BulkDiscount.new
  end

  def create
    bulk_discount = BulkDiscount.new(bulk_discount_params)
    bulk_discount.merchant_id = @merchant.id
    if bulk_discount.save
      flash[:notice] = "New discount was successfully created."
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      render :new
    end
  end

  private
  def bulk_discount_params
    params.require(:bulk_discount).permit(:discount_percentage, :minimum_quantity)
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end

