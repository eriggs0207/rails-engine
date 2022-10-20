class Api::V1::SearchController < ApplicationController

  def find
    if params[:name]
      render json: MerchantSerializer.new(Merchant.merchant_search(params[:name]))
    elsif params[:name] = nil
      render json: { data: {message: 'parameter cannot be missing'}}, status: 400
    else
      render status: :no_content
    end
  end

  def find_all
    if params[:name]
      render json: ItemSerializer.new(Item.items_search_by_name(params[:name]))
    elsif params[:min_price] && !params[:max_price]
      render json: ItemSerializer.new(Item.items_search_by_min(params[:min_price]))
      binding.pry 
    # elsif params[:min_price] && params[:min_price].to_i > 0
    #   render json: { data: {message: 'min price cannot be less than 0'}}, status: 400
    #

    elsif params[:max_price] && !params[:min_price]
      render json: ItemSerializer.new(Item.items_search_by_max(params[:max_price]))
    elsif params[:max_price] && params[:min_price]
      render json: ItemSerializer.new(Item.items_search_by_range(params[:max_price], params[:min_price]))
    elsif params[:max_price] && params[:min_price] && params[:name]
      render json: { data: {message: 'cannot send both name and min_price and max_price'}}, status: 400
    elsif params[:min_price] && params[:name]
      render json: { data: {message: 'cannot send both name and min_price'}}, status: 400
    elsif params[:max_price] && params[:name]
      render json: { data: {message: 'cannot send both name and max_price'}}, status: 400
    else
      render status: :no_content
    end
  end
end
