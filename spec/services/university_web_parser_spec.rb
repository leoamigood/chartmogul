# frozen_string_literal: true

require 'rails_helper'
describe UniversityWebParser do
  context 'when payload is empty list' do
    let(:payload) { '[]' }

    it 'constructs empty list' do
      universities = described_class.digest(payload)

      expect(universities).to be_empty
    end
  end

  context 'when payload contains universities' do
    let(:payload) { file_fixture('finland.json').read }

    it 'constructs university list' do
      universities = described_class.digest(payload)

      expect(universities.count).to eq(70)
    end
  end

  context 'when payload is incorrectly formed json' do
    let(:payload) { '' }

    it 'raises json parsing error' do
      expect { described_class.digest(payload) }.to raise_error(JSON::ParserError)
    end
  end
end
