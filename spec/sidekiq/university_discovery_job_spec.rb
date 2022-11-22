# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

describe UniversityDiscoveryJob, type: :job do
  specify { is_expected.to be_processed_in :discovery }
  specify { is_expected.to be_retryable true }

  context 'when job is enqueued' do
    before do
      Sidekiq::Testing.fake!
    end

    it 'queue increases in size' do
      expect do
        described_class.perform_async('country')
      end.to change(described_class.jobs, :size).by(1)
    end
  end

  context 'when job is executed' do
    before do
      Sidekiq::Testing.inline!
    end

    after do
      Sidekiq::Testing.fake!
    end

    context 'when university resources not found' do
      let(:country) { 'Russia' }

      before do
        allow(UniversityWebDiscoverer).to receive(:process).and_return([])
      end

      it 'no university records created' do
        expect do
          described_class.perform_async(country)
        end.not_to change(University, :count)
      end
    end

    context 'when university resources successfully discovered' do
      let(:country) { 'Finland' }
      let(:universities) { build_list(:university, 15, country:) }

      before do
        allow(UniversityWebDiscoverer).to receive(:process).and_return(universities)
      end

      it 'university records persisted' do
        expect do
          described_class.perform_async(country)
        end.to change(University, :count).by(15)
      end

      context 'when some university resources already exist' do
        let!(:existing) { create(:university, name: universities.sample.name, country:) }

        it 'duplicate university records omitted' do
          expect do
            described_class.perform_async(country)
          end.to change(University, :count).by(14)
        end
      end

      context 'when duplicate university records discovered' do
        let(:abo) { build(:university, name: 'Abo Akademi University', country:) }
        let(:lahti) { build(:university, name: 'Lahti Polytechnic', country:) }
        let(:lappeenranta) { build(:university, name: 'Lappeenranta University of Technology', country:) }
        let(:oulu) { build(:university, name: 'Oulu Polytechnic', country:) }

        let(:universities) { [abo, lahti, lappeenranta, oulu, abo, abo, lahti] }

        it 'duplicate university records ignored' do
          expect do
            described_class.perform_async(country)

            expect(University.all).to contain_exactly(abo, lahti, lappeenranta, oulu)
          end.to change(University, :count).by(4)
        end
      end
    end

    context 'when university resources discovery failed' do
      let(:country) { 'Germany' }

      before do
        allow(UniversityWebDiscoverer).to receive(:process).and_raise(Exception)
      end

      it 'no university records created' do
        expect do
          expect { described_class.perform_async(country) }.to raise_error(Exception)
        end.not_to change(University, :count)
      end
    end

    context 'with mocked successful http response', integration: true do
      let(:country) { 'Finland' }
      let(:payload) { file_fixture('finland.json').read }

      it 'university records persisted' do
        stub_request(:get, "#{UniversityWebLoader::HIPOLABS_URL}/search")
          .with(
            query:   { 'country' => country },
            headers: {
              'Content-Type' => 'application/json'
            }
          )
          .to_return(status: 200, body: payload, headers: {})

        expect do
          described_class.perform_async(country)
        end.to change(University, :count).by(35)
      end
    end

    context 'with mocked not found http response', integration: true do
      let(:country) { 'Finland' }

      it 'university records persisted' do
        stub_request(:get, "#{UniversityWebLoader::HIPOLABS_URL}/search")
          .with(
            query:   { 'country' => country },
            headers: {
              'Content-Type' => 'application/json'
            }
          )
          .to_return(status: 404, headers: {})

        expect do
          described_class.perform_async(country)
        end.to avoid_changing(University, :count).and raise_error(StandardError)
      end
    end
  end
end
