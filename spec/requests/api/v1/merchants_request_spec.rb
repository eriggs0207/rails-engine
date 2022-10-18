require 'rails_helper'

describe "Merchants API" do
  it "sends a list of all merchants" do
    create_list(:merchant, 10)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants.count).to eq(10)
    expect(merchants[0]).to have_key(:id)
    expect(merchants[1][:id]).to be_an(Integer)
    expect(merchants[3]).to have_key(:name)
    expect(merchants[2][:name]).to be_a(String)
  end
end
