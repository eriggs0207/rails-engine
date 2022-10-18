require 'rails_helper'

describe "Items API" do
  it "sends a list of all items" do
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

  it "can get one item by its id" do
    item = create(:item)

    get api_v1_item_path(item)

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item[:data]).to have_key(:id)
    expect(item[:data]).to have_key(:attributes)
    expect(item[:data][:attributes][:name]).to be_a(String)
    expect(item[:data][:attributes][:merchant_id]).to be_a(Integer)
    expect(item[:data][:attributes][:unit_price]).to be_a(Float)
  end

  it "can create a new item" do
    merchant = create(:merchant)
    item_params = ({
                    name: 'Chair',
                    description: 'It is a chair',
                    unit_price: 3.99,
                    merchant_id: merchant.id

                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last

    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end

end
