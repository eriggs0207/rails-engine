class Api::V1::MerchantsController < ApplicationController

  def index
    merchants = render json: Merchant.all 
  end

end
