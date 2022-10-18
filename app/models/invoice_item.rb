class InvoiceItem < ApplicationRecord
  validates_presence_of :quantity, :unit_price
  validates :quantity, numericality: true
  validates :unit_price, numericality: true

  belongs_to :item
  belongs_to :invoice

end 
