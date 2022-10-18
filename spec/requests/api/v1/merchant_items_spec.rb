require 'rails_helper'

describe "Merchant-Items API" do
  it "sends a list of all items by merchant" do
    merchant = create(:merchant)
    items = create_list(:item, 10, merchant: merchant)


    get api_v1_merchant_items_path(merchant)

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(10)
    expect(items[:data][1]).to have_key(:id)
    expect(items[:data][3]).to have_key(:attributes)
    expect(items[:data][9][:attributes][:name]).to be_a(String)
    expect(items[:data][4][:attributes][:merchant_id]).to eq(merchant.id)
    expect(items[:data][5][:attributes][:unit_price]).to be_a(Float)
  end
end
