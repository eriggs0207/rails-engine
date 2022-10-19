class Api::V1::ItemsController < ApplicationController

  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    item = Item.find(params[:id])
    if item.present?
      render json: ItemSerializer.new(item)
    else
      render status: :not_found
    end
  end

  def create
    item = Item.create(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: :created
    else
      render status: :not_found
    end
  end

  def update
    item = Item.find(params[:id])
    if item.update(item_params)
      render json: ItemSerializer.new(item)
    else
      render status: :not_found
    end
  end

  def destroy
    item = Item.find(params[:id])
    if item.destroy
      render status: :no_content
    end
  end

  private

  def item_params
    params.require(:item).permit(:name,:description,:unit_price,:merchant_id)
  end
end
