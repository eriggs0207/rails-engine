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
        merchant = create(:merchant)
        item2 = create(:item, name: "Greater Item", merchant: merchant)
        item1 = create(:item, name: "Great Item", merchant: merchant)
        item3 = create(:item, name: "Greatest Item", merchant: merchant)
        item4 = create(:item, name: "ZZZZZZZZ", merchant: merchant)

        expect(Item.items_search_by_name("gReat")).to eq([item2, item1, item3])
      end
    end
  end
end
