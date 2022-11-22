# frozen_string_literal: true

class UniversityDiscoveryJob
  include Sidekiq::Job

  sidekiq_options queue: :discovery

  def perform(country)
    universities = UniversityWebDiscoverer.process(country)
    universities.each do |university|
      UniversityProcessorJob.perform_async(university.name, university.country)
    end
  end
end
