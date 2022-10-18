class MerchantSerializer
  include JSONAPI::Serializer
  has_many :items
  attributes :name
end
