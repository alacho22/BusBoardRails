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

  def is_postcode_valid(possible_postcode)
    uri = get_validate_postcode_uri(possible_postcode)
    json_result = Net::HTTP.get_response(uri)
    result = json_result.is_a?(Net::HTTPSuccess) ? JSON.parse(json_result.body) : nil
    if result.nil?
      false
    else
      result["result"]
    end
  end

  private

  def get_postcode_lat_long_uri(postcode)
    URI::HTTP.build(host: "api.postcodes.io", path: "/postcodes/#{ERB::Util::url_encode(postcode)}")
  end

  def get_validate_postcode_uri(possible_postcode)
    URI::HTTP.build(host: "api.postcodes.io", path: "/postcodes/#{ERB::Util::url_encode(possible_postcode)}/validate")
  end
end
