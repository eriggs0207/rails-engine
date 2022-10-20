class Api::V1::SearchController < ApplicationController

  def find
    if params[:name]
      render json: MerchantSerializer.new(Merchant.merchant_search(params[:name]))
    else
      render status: :not_found
    end
  end

  def find_all
    if params[:name]
      render json: ItemSerializer.new(Item.items_search_by_name(params[:name]))
    elsif params[:min_price] && !params[:max_price]
      render json: ItemSerializer.new(Item.items_search_by_min(params[:min_price]))
    elsif params[:max_price] && !params[:min_price]
      render json: ItemSerializer.new(Item.items_search_by_max(params[:max_price]))

    else
      render status: :not_found
    end
  end
end
