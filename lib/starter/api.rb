require "net/http"
require "json"

module Starter
  class Api
    URL = "https://damp-peak-95509.herokuapp.com/"

    def run
      uri = URI(URL)
      response = Net::HTTP.get(uri)
      JSON.parse(response, symbolize_names: true)
    end
  end
end
