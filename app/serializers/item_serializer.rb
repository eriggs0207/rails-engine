class ItemSerializer
  include JSONAPI::Serializer
  belongs_to :merchant
  attributes :name, :description, :unit_price
end
