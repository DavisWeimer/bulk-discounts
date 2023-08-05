class BulkDiscountsController < ApplicationController
  before_action :find_bulk_discount_and_merchant, only: [:edit, :update, :show, :destroy]
  before_action :find_merchant, only: [:new, :create, :index]

  def index
    @bulk_discounts = @merchant.bulk_discounts
  end

  def new
    @bulk_discount = BulkDiscount.new
  end

  def create
    bulk_discount = @merchant.bulk_discounts.new(bulk_discount_params)
    if bulk_discount.save
      flash[:notice] = "New discount was successfully created."
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      flash[:alert] = "Discount percentage must be between 0.01 and 0.99"
      render :new
    end
  end
  
  def destroy
    @bulk_discount.destroy
    flash[:notice] = "Discount was successfully deleted."
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  def show; end

  def edit; end

  def update
    
  end

  private
  def bulk_discount_params
    params.require(:bulk_discount).permit(:discount_percentage, :minimum_quantity)
  end

  def find_bulk_discount_and_merchant
    @bulk_discount = BulkDiscount.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end

