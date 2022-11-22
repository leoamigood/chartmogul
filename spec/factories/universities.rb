# frozen_string_literal: true

FactoryBot.define do
  factory :university do
    name            { FFaker::Name.name }
    country         { FFaker::Address.country }
  end
end
