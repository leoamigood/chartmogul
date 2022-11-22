# frozen_string_literal: true

require 'rails_helper'

describe University do
  let(:oulu) { build(:university, name: 'Oulu Polytechnic', country: 'Finland') }
  let(:poland) { build(:university, name: 'State University', country: 'Poland') }
  let(:finland) { build(:university, name: 'State University', country: 'Finland') }
  let(:state) { create(:university, name: 'State University', country: 'Finland') }

  it 'equals matches name and country' do
    expect(finland).to eq(state)
    expect(finland).not_to eq(oulu)
    expect(finland).not_to eq(poland)
  end

  it 'persists successfully' do
    expect { described_class.new(name: 'Name', country: 'Country').save! }.to change(described_class, :count).by(1)
  end

  it 'fails to persist with missing fields' do
    expect { described_class.new(name: 'Name').save! }.to raise_error(ActiveRecord::RecordInvalid)
    expect { described_class.new(country: 'Country').save! }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
