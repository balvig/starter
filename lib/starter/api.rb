require "net/http"
require "json"

module Starter
  class Api
    URL = "https://starter-api-production.herokuapp.com/"

    def run
      uri = URI(URL)
      response = Net::HTTP.get(uri)
      JSON.parse(response, symbolize_names: true)
      rescue JSON::ParserError
        nil
    end
  end
end
