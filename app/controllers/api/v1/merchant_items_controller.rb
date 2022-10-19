class Api::V1::MerchantItemsController < ApplicationController

  def index
    merchant = Merchant.find(params[:merchant_id])
    if merchant.present?
      render json: ItemSerializer.new(merchant.items)
    else
      render status: :not_found
    end
  end
end
