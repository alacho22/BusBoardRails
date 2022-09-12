require 'uri'
require 'net/http'
require 'json'

class TflInterfaceController < ApplicationController
  def initialize
    super
    @bus_stop_types = ["NaptanBusCoachStation", "NaptanBusWayPoint", "NaptanHailAndRideSection", "NaptanOnstreetBusCoachStopCluster", "NaptanOnstreetBusCoachStopPair", "NaptanPublicBusCoachTram", "TransportInterchange"]
  end

  def get_all_arrivals(stop_ids)
    all_arrivals = []
    stop_ids.each do |stop_id|
      arrival =  get_arrivals(stop_id)
      all_arrivals += arrival
    end
    all_arrivals
  end

  def get_stop_ids(stop)
    ids = []
    stop["children"].each { |child| ids << child["naptanId"] }
    ids
  end

  def get_nearest_stops(lat, lon)
    uri = get_nearest_stop_uri(lat, lon)
    res = Net::HTTP.get_response(uri)
    json_res = JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)
    stops = json_res["stopPoints"]
    stops.sort_by! { |stop| stop["distance"] }
    stops
  end

  def get_arrivals(stop_id)
    uri = get_arrivals_uri(stop_id)
    json_results = Net::HTTP.get_response(uri)
    results = JSON.parse(json_results.body) if json_results.is_a?(Net::HTTPSuccess)
    results.each { |arrival| arrival[:minsToStation] = (arrival["timeToStation"] / 60.to_f).ceil }

    model_results = results.map { |result| BusArrival.create(line_number: result["lineName"], destination: result["destinationName"], mins_to_arrive: result[:minsToStation]) }
    model_results
  end


  private

  def get_arrivals_uri(stop_id)
    URI("https://api.tfl.gov.uk/StopPoint/#{stop_id}/Arrivals")
  end

  def get_nearest_stop_uri(lat, lon)
    base_uri = URI("https://api.tfl.gov.uk/StopPoint")
    params = {
      :lat => lat,
      :lon => lon,
      :stopTypes => @bus_stop_types.join(",")
    }
    base_uri.query = URI.encode_www_form(params)
    base_uri
  end
end
