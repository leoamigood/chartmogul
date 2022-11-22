# frozen_string_literal: true

require 'rails_helper'
describe UniversityWebLoader do
  context 'when universities country argument is not acceptable' do
    it 'raises guarding exception' do
      expect { described_class.retrieve(nil) }.to raise_error(StandardError)
      expect { described_class.retrieve(123) }.to raise_error(StandardError)
      expect { described_class.retrieve(:finland) }.to raise_error(StandardError)
    end
  end

  context 'when universities country argument is acceptable' do
    let(:country) { 'Finland' }
    let(:response_body) { file_fixture('finland.json').read }

    it 'returns response body when request is formed correctly' do
      stub = stub_request(:get, "#{UniversityWebLoader::HIPOLABS_URL}/search")
             .with(query: { 'country' => country }, headers: { 'Content-Type' => 'application/json' })
             .to_return(status: 200, body: response_body, headers: {})

      expect(described_class.retrieve(country)).to eq(response_body)

      expect(stub).to have_been_requested.once
    end

    it 'raises exception when incorrect response' do
      stub = stub_request(:get, "#{UniversityWebLoader::HIPOLABS_URL}/search")
             .with(query: { 'country' => country }, headers: { 'Content-Type' => 'application/json' })
             .to_return(status: 500, headers: {})

      expect { described_class.retrieve(country) }.to raise_error(StandardError)

      expect(stub).to have_been_requested.once
    end
  end
end
