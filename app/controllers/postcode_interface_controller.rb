require 'uri'
require 'net/http'
require 'json'
require 'erb'

class PostcodeInterfaceController < ApplicationController
  def get_postcode_lat_long(postcode)
    uri = get_postcode_lat_long_uri(postcode)
    res = Net::HTTP.get_response(uri)
    json_res = (JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess))["result"]
    {
      :lat => json_res["latitude"],
      :lon => json_res["longitude"]
    }
  end

  private

  def get_postcode_lat_long_uri(postcode)
    URI::HTTP.build(host: "api.postcodes.io", path: "/postcodes/#{ERB::Util::url_encode(postcode)}")
  end
end
