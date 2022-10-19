require 'rails_helper'

describe "Merchants API" do
  it "sends a list of all merchants" do
    create_list(:merchant, 10)

    get api_v1_merchants_path

    expect(response).to be_successful
    expect(response.status).to eq(200)

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(10)
    expect(merchants[:data]).to be_an(Array)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it "can get one merchant by its id" do
    merchant = create(:merchant)

    get api_v1_merchant_path(merchant)

    expect(response).to be_successful
    expect(response.status).to eq(200)

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data]).to have_key(:attributes)
    expect(merchant[:data][:attributes][:name]).to be_a(String)
  end

  it 'returns a no_content status for invalid id' do
    merchant = create(:merchant)

    get "/api/v1/merchants/0"

    expect(response).to_not be_successful
    expect(response.status).to eq(404)
  end

  it 'returns one merchant based on a search' do
    merchant1 = create(:merchant, name: "Home Depot")
    merchant2 = create(:merchant, name: "Home Goods")
    merchant3 = create(:merchant, name: "Google Home")
    merchant4 = create(:merchant, name: "Jim Thome Stuff")
    merchant5 = create(:merchant, name: "ZZZZZZ")

    get "/api/v1/merchants/find?name=jim"
     
    expect(response).to be_successful
    expect(response.status).to eq(200)

    json_response = JSON.parse(response.body, symbolize_names: true)
    merchant = json_response[:data]

    expect(merchant).to be_an(Array)
    expect(merchant).to have_key(:attributes)
    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a(String)
  end
end
