FactoryBot.define do
  factory :customer do
    first_name {Faker::Military.army_rank }
    last_name {Faker::Food.ingredient}
  end

  factory :invoice do
    status {[:cancelled, :in_progress, :completed].sample}
  end

  factory :merchant do
    name {"#{Faker::TvShows::Simpsons.character} #{Faker::Company.industry}"}
    trait :invoices do
      invoices { association(:invoice) }
    end
    trait :items do
      items { association(:item) }
    end
  end

  factory :item do
    name {"#{Faker::Emotion.adjective.capitalize} #{[Faker::Games::DnD.melee_weapon, Faker::Games::DnD.ranged_weapon, Faker::Appliance.equipment, Faker::Games::ElderScrolls.weapon, Faker::Beer.style, Faker::Food.dish].sample.capitalize}"}
    description {Faker::TvShows::Spongebob.quote}
    unit_price { Faker::Number.decimal(l_digits: 2)}
  end

  factory :transaction do
    credit_card_number {Faker::Number.number(digits:16)}
    credit_card_expiration_date {"04/27"}
    result {[:failed, :success].sample}
  end

  factory :invoice_item do
    quantity {rand(1..10)}
    unit_price { Faker::Commerce.price }
    status {[:shipped, :packaged, :pending].sample}
  end

  factory :bulk_discount do
    discount_percentage { rand(0.01..0.99) }
    minimum_quantity { rand(10..20) }
  end

  factory :item_bulk_discount do

  end
end
