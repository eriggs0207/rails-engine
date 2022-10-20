class Item < ApplicationRecord
  validates_presence_of :name, :description, :unit_price
  validates :unit_price, numericality: true

  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.items_search_by_name(item_term)
    where("name ILIKE ?", "%#{item_term}%")
    .order(name: :desc)
  end

  def self.items_search_by_min(item_min)
    where("unit_price >= ?", item_min)
  end

  def self.items_search_by_max(item_max)
    where("unit_price <= ?", item_max)
  end

  def self.items_search_by_range(max, min)
    where("unit_price BETWEEN ? AND ?", min, max)
  end
end
