# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

describe UniversityProcessorJob, type: :job do
  specify { is_expected.to be_processed_in :processor }
  specify { is_expected.to be_retryable true }

  context 'when job is enqueued' do
    before do
      Sidekiq::Testing.fake!
    end

    it 'queue increases in size' do
      expect do
        described_class.perform_async('university', 'country')
      end.to change(described_class.jobs, :size).by(1)
    end
  end
end
