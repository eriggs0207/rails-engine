require 'rails_helper'

describe "Items API" do
  it "sends a list of all items" do
    create_list(:item, 10)

    get api_v1_items_path

    expect(response).to be_successful
    expect(response.status).to eq(200)

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(10)
    expect(items[:data]).to be_an(Array)

    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item).to have_key(:attributes)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes][:merchant_id]).to be_a(Integer)
      expect(item[:attributes][:unit_price]).to be_a(Float)
    end
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

  it 'returns a no_content status for invalid id' do
    item = create(:item)

    get "/api/v1/items/0"

    expect(response).to_not be_successful
    expect(response.status).to eq(404)
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

  it "will return no_content status with incomplete item attributes" do
    merchant = create(:merchant)
    item_params = ({
                    name: 'Chair',
                    description: 'It is a chair',
                    merchant_id: merchant.id

                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    expect(response).to_not be_successful
    expect(response.status).to eq(404)
  end

  it "can update an existing item" do
    id = create(:item).id
    previous_price = Item.last.unit_price
    item_params = { unit_price: 45.99 }
    headers = {"CONTENT_TYPE" => "application/json"}

    # We include this header to make sure that these params are passed as JSON rather than as plain text
    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: id)

    expect(response).to be_successful
    expect(item.unit_price).to_not eq(previous_price)
    expect(item.unit_price).to eq(45.99)
  end

  it "will return no_content status with incorrect id" do
    id = create(:item).id
    previous_price = Item.last.unit_price
    item_params = { unit_price: 45.99, merchant_id: 0 }
    headers = {"CONTENT_TYPE" => "application/json"}

    # We include this header to make sure that these params are passed as JSON rather than as plain text
    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: id)

    expect(response).to_not be_successful
    expect(response.status).to eq(404)
  end

    it "can destroy an item" do
    item = create(:item)

    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{item.id}"

    expect(response).to be_successful
    expect(response.status).to eq(204)

    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  describe 'search for all items' do
    it 'returns items based on a name search' do
      # merchant = create(:merchant)
      item1 = create(:item, name: "ring")
      item2 = create(:item, name: "ball bearing")
      item3 = create(:item, name: "earing")
      item4 = create(:item, name: "eeeeeee")

      get "/api/v1/items/find_all?name=ring"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      json_response = JSON.parse(response.body, symbolize_names: true)
      items = json_response[:data]

      expect(items).to be_an(Array)
      expect(items.count).to eq(3)
    end


    it 'returns items based on a min unit price search' do
      # merchant = create(:merchant)
      item1 = create(:item, unit_price: 9.99)
      item2 = create(:item, unit_price: 10.01)
      item3 = create(:item, unit_price: 1000.10)
      item4 = create(:item, unit_price: 11.11)

      get "/api/v1/items/find_all?min_price=10.02"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      json_response = JSON.parse(response.body, symbolize_names: true)
      items = json_response[:data]

      expect(items).to be_an(Array)
      expect(items.count).to eq(2)
    end

    it 'returns items based on a max unit price search' do
      # merchant = create(:merchant)
      item1 = create(:item, unit_price: 9.99)
      item2 = create(:item, unit_price: 10.01)
      item3 = create(:item, unit_price: 1000.10)
      item4 = create(:item, unit_price: 11.11)

      get "/api/v1/items/find_all?max_price=12.02"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      json_response = JSON.parse(response.body, symbolize_names: true)
      items = json_response[:data]

      expect(items).to be_an(Array)
      expect(items.count).to eq(3)
    end
  end
end
