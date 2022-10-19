class Api::V1::ItemsMerchantController < ApplicationController

  def index
    item = Item.find(params[:item_id])
    if item.present?
      render json: MerchantSerializer.new(Merchant.find(item.merchant_id))
    else
      render status: :not_found
    end
  end
end
