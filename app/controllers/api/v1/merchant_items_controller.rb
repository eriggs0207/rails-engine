class Api::V1::MerchantItemsController < ApplicationController

  def index
    if Merchant.exists?(params[:merchant_id])
      merchant = Merchant.find(params[:merchant_id])
      render json: ItemSerializer.new(merchant.items)
    else
      render status: :not_found
    end
  end
end
