require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
    it { should validate_numericality_of(:unit_price) }
  end

  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'class methods' do
    describe '#items_search_by_name' do
      it 'returns items based on keywords' do

        item1 = create(:item, name: "brine")
        item2 = create(:item, name: "ring")
        item3 = create(:item, name: "grinder")
        item4 = create(:item, name: "ZZZZZZZZ")

        expect(Item.items_search_by_name("riN")).to eq([item2, item3, item1])
      end
    end

    describe '#items_search_by_min' do
      it 'returns items based on a min unit_price' do

        item1 = create(:item, unit_price: 9.99)
        item2 = create(:item, unit_price: 10.02)
        item3 = create(:item, unit_price: 1000.10)
        item4 = create(:item, unit_price: 11.11)

        expect(Item.items_search_by_min(10.01)).to eq([item2, item3, item4])
      end
    end

    describe '#items_search_by_max' do
      it 'returns items based on a max unit_price' do

        item1 = create(:item, unit_price: 9.99)
        item2 = create(:item, unit_price: 10.02)
        item3 = create(:item, unit_price: 1000.10)
        item4 = create(:item, unit_price: 11.11)

        expect(Item.items_search_by_max(12.01)).to eq([item1, item2, item4])
      end
    end

    describe '#items_search_by_range' do
      it 'returns items based on a price range' do

        item1 = create(:item, unit_price: 9.99)
        item2 = create(:item, unit_price: 10.02)
        item3 = create(:item, unit_price: 1000.10)
        item4 = create(:item, unit_price: 11.11)

        expect(Item.items_search_by_range(12, 9)).to eq([item1, item2, item4])
      end
    end
  end
  describe 'instance methods' do
    describe '#invoices_by_item' do
      it 'returns invoices by item' do
        merchant = create(:merchant)
        customer = create(:customer)
        item1 = create(:item, merchant: merchant)
        item2 = create(:item, merchant: merchant)
        invoice1 = create(:invoice, customer: customer, merchant: merchant)
        invoice2 = create(:invoice, customer: customer, merchant: merchant)
        invoice3 = create(:invoice, customer: customer, merchant: merchant)
        invoice4 = create(:invoice, customer: customer, merchant: merchant)
        create(:invoice_items, item_id: item1.id, invoice_id: invoice1.id)
        create(:invoice_items, item_id: item1.id, invoice_id: invoice2.id)
        create(:invoice_items, item_id: item2.id, invoice_id: invoice3.id)
        create(:invoice_items, item_id: item1.id, invoice_id: invoice4.id)

        expect(item1.invoices_by_item).to eq([invoice1, invoice2, invoice4])
      end
    end
  end
end
