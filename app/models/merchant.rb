class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items
  has_many :invoices
  has_many :customers, through: :invoices

  def self.merchant_search(merchant_term)
    where("name ILIKE ?", "%#{merchant_term}%")
    .order(name: :desc).first
  end

end
