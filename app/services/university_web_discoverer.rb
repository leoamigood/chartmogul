# frozen_string_literal: true

class UniversityWebDiscoverer
  class << self
    def process(country)
      response = UniversityWebLoader.retrieve(country)
      universities = UniversityWebParser.digest(response)

      Rails.logger.info("Discovered #{universities.size} universities in country #{country}")

      universities
    end
  end
end
