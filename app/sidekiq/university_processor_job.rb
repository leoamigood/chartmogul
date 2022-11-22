# frozen_string_literal: true

class UniversityProcessorJob
  include Sidekiq::Job

  sidekiq_options queue: :processor

  def perform(university, country)
    persist(university, country)
  end

  def persist(university, country)
    DatabaseUniversityPersister.store(university, country)
  end
end
