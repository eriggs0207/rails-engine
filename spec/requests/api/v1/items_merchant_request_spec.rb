require 'rails_helper'

describe "Items-merchant API" do
  it "return the merchant associated with an item" do
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)

    get api_v1_item_merchant_index_path(item)
    # get  "/api/v1/items/#{item.id}/merchant"

    expect(response).to be_successful
    expect(response.status).to eq(200)

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant[:data]).to be_a(Hash)
    expect(merchant[:data][:id]).to eq("#{item.merchant_id}")
    expect(merchant[:data]).to have_key(:type)
    expect(merchant[:data]).to have_key(:attributes)
    expect(merchant[:data][:attributes][:name]).to be_a(String)
  end

  it 'returns a no_content status for invalid id' do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)

    get "/api/v1/items/0/merchant"

    expect(response).to_not be_successful
    expect(response.status).to eq(404)
  end
end
