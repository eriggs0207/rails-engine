FactoryBot.define do
  factory :merchant, class: Merchant do
    name {Faker::Name.name}
  end

  factory :item, class: Item do
    name        {Faker::Commerce.product_name}
    description {Faker::Marketing.buzzwords}
    unit_price  {Faker::Number.within(range: 500..2000)}
    association :merchant, factory: :merchant
  end

  factory :invoice, class: Invoice do
    status {Faker::Number.within(range: 0..2)}
    association :customer, factory: :customer
    association :merchant, factory: :merchant
  end

  factory :customer, class: Customer do
    first_name {Faker::Name.first_name}
    last_name {Faker::Name.last_name}
  end

  factory :invoice_items, class: InvoiceItem do
    quantity {Faker::Number.within(range: 1..20)}
    unit_price {Faker::Number.within(range: 500..2000)}
    association :invoice, factory: :invoice
    association :item, factory: :item
  end
end
