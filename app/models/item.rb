class Item < ApplicationRecord
  validates_presence_of :name, :description, :unit_price
  validates :unit_price, numericality: true

  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.items_search_by_name(item_term)
    where("name ILIKE ?", "%#{item_term}%")
  end
end
