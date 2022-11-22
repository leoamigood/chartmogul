# frozen_string_literal: true

class UniversityWebParser
  class << self
    def digest(payload)
      universities = JSON.parse payload

      universities.map do |university|
        University.new(name: university['name'], country: university['country'])
      end
    end
  end
end
