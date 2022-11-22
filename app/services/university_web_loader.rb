# frozen_string_literal: true

class UniversityWebLoader
  HIPOLABS_URL = 'http://universities.hipolabs.com'

  class << self
    def retrieve(country)
      raise StandardError, "unacceptable country value: #{country}" unless country.is_a? String

      conn = Faraday.new(
        url:     HIPOLABS_URL,
        headers: { 'Content-Type' => 'application/json' }
      )

      response = conn.get('/search') do |req|
        req.params['country'] = country
      end

      raise StandardError, "Hipolabs API response: #{response}" unless response.status == 200

      response.body
    end
  end
end
