require 'rails_helper'

describe "Merchant-Items API" do
  it "sends a list of all items by merchant" do
    merchant = create(:merchant)
    items = create_list(:item, 10, merchant: merchant)

    get api_v1_merchant_items_path(merchant)

    expect(response).to be_successful
    expect(response.status).to eq(200)

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(10)

    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item).to have_key(:attributes)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes][:merchant_id]).to eq(merchant.id)
      expect(item[:attributes][:unit_price]).to be_a(Float)
    end
  end
end
