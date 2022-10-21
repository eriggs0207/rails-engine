class Api::V1::SearchController < ApplicationController

  def find
    if !params[:name] || params[:name] == ""
      render json: {error: {message: "must enter name"}}, status: 400
    else
      merchant = Merchant.merchant_search(params[:name])
        if !merchant.nil?
          render json: MerchantSerializer.new(merchant)
        else
          render json: {data: {}}
        end
      end
    end


  def find_all
    if params[:name] && params[:max_price]
      render json: {error: {message: "cannot send both name and max_price"}}, status: 400
    elsif params[:name] && params[:min_price]
      render json: {error: {message: "cannot send both name and min_price"}}, status: 400
    elsif params[:name] && params[:max_price] && params[:min_price]
      render json: {error: {message: "cannot send both name and min_price and max_price"}}, status: 400
    elsif params[:min_price].present? && (params[:min_price].to_f < 0)
      render json: {error: {message: "min_price cannot be less than zero"}}, status: 400
    elsif params[:max_price].present? && (params[:max_price].to_f < 0)
      render json: {error: {message: "max_price cannot be less than zero"}}, status: 400
    elsif params[:max_price].present? && params[:min_price].present? && (params[:min_price].to_f) >= (params[:max_price].to_f)
      render json: {error: {message: "max_price must be greater than min_price"}}, status: 400
    else
      if params[:name]
        render json: ItemSerializer.new(Item.items_search_by_name(params[:name]))
      elsif params[:max_price] && params[:min_price]
        render json: ItemSerializer.new(Item.items_search_by_range(params[:max_price], params[:min_price]))
      elsif params[:min_price]
        render json: ItemSerializer.new(Item.items_search_by_min(params[:min_price]))
      elsif params[:max_price]
        render json: ItemSerializer.new(Item.items_search_by_max(params[:max_price]))
      end
    end
  end
end

# elsif params[:max_price] && params[:min_price] && params[:name]
#   render json: { data: {message: 'cannot send both name and min_price and max_price'}}, status: 400
# elsif params[:min_price] && params[:name]
#   render json: { data: {message: 'cannot send both name and min_price'}}, status: 400
# elsif params[:max_price] && params[:name]
#   render json: { data: {message: 'cannot send both name and max_price'}}, status: 400
