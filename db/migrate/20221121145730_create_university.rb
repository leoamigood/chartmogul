# frozen_string_literal: true

class CreateUniversity < ActiveRecord::Migration[7.0]
  def change
    create_table :universities do |t|
      t.string    :name, null: false
      t.string    :country, null: false

      t.timestamps
    end
    add_index :universities, %i[name country], unique: true
  end
end
