class Api::V1::MerchantItemsController < ApplicationController

  def index
    merchant = Merchant.find(params[:merchant_id])
    if merchant.present?
      render json: ItemSerializer.new(merchant.items)
    else
      render status: :no_content
    end 
  end
end
