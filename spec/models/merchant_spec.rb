require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
  end
  describe 'relationships' do
    it { should have_many(:items) }
    it { should have_many(:invoices) }
    it { should have_many(:customers).through(:invoices) }
  end

  describe 'class methods' do
    describe '#merchant_search' do
      it 'returns the first merchant based on keywords' do
        merchant1 = create(:merchant, name: "Great Merchant")
        merchant2 = create(:merchant, name: "Greater Merchant")
        merchant3 = create(:merchant, name: "Greatest Merchant")

        expect(Merchant.merchant_search("greatest")).to eq(merchant3)
      end
    end
  end
end
