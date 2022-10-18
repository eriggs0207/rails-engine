class Api::V1::MerchantsController < ApplicationController

  def index
    merchants = render json: Merchant.all
  end

  def show
    merchant = render json: Merchant.find(params[:id])
  end 

end
