# frozen_string_literal: true

class DatabaseUniversityPersister
  class << self
    def store(name, country)
      University.find_or_create_by!(name:, country:)
    end
  end
end
