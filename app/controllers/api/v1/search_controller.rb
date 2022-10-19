class Api::V1::SearchController < ApplicationController

  def find
    merchant = Merchant.merchant_search(params[:name])
    if merchant != nil
      render json: MerchantSerializer.new(merchant)
    else
      render status: :not_found
    end
  end
end
