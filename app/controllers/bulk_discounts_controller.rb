class BulkDiscountsController < ApplicationController
  before_action :find_merchant, only: [:index]

  def index
    @bulk_discounts = @merchant.bulk_discounts
  end

  private
  def bulk_discount_params
    params.require(:bulk_discount).permit(:discount_percentage, :minimum_quantity)
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end

