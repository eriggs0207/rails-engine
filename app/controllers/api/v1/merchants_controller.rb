class Api::V1::MerchantsController < ApplicationController

  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    merchant = Merchant.find(params[:id])
    if merchant.present?
      render json: MerchantSerializer.new(merchant)
    else
      render status: :no_content
    end 
  end

end
