# frozen_string_literal: true

class University < ApplicationRecord
  validates :name, presence: true
  validates :country, presence: true

  def ==(other)
    name == other.name && country == other.country
  end
end
