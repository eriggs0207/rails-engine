require 'rails_helper'

describe "Merchants API" do
  it "sends a list of all merchants" do
    create_list(:item, 10)

    get api_v1_items_path

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(10)
    expect(items[:data]).to be_an(Array)
    expect(items[:data][0]).to have_key(:id)
    expect(items[:data][3]).to have_key(:attributes)
    expect(items[:data][2][:attributes][:name]).to be_a(String)
    expect(items[:data][2][:attributes][:merchant_id]).to be_a(Integer)
    expect(items[:data][2][:attributes][:unit_price]).to be_a(Float)
  end
end 
