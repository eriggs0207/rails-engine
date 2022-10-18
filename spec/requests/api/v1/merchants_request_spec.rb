require 'rails_helper'

describe "Merchants API" do
  it "sends a list of all merchants" do
    create_list(:merchant, 10)

    get api_v1_merchants_path

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(10)
    expect(merchants[:data]).to be_an(Array)
    expect(merchants[:data][0]).to have_key(:id)
    expect(merchants[:data][3]).to have_key(:attributes)
    expect(merchants[:data][2][:attributes][:name]).to be_a(String)
  end

  it "can get one merchant by its id" do
    merchant = create(:merchant)

    get api_v1_merchant_path(merchant)

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data]).to have_key(:attributes)
    expect(merchant[:data][:attributes][:name]).to be_a(String)
  end
end
