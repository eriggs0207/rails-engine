class Api::V1::ItemsMerchantController < ApplicationController

  def index
    if Item.exists?(params[:item_id])
      item = Item.find(params[:item_id])
      render json: MerchantSerializer.new(Merchant.find(item.merchant_id))
    else
      render status: :not_found
    end
  end
end
