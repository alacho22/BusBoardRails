class PagesController < ApplicationController

  def initialize
    super
    @postcode_interface = PostcodeInterfaceController.new
    @tfl_interface = TflInterfaceController.new
  end

  def index
    params.permit(:postcode, :commit)
    postcode = params[:postcode]
    @bus_stop_arrivals_infos = []
    @postcode_error_msg = nil
    if postcode
      if @postcode_interface.is_postcode_valid(postcode)
        postcode_lat_lon = @postcode_interface.get_postcode_lat_long(postcode)
        postcode_lat = postcode_lat_lon[:lat]
        postcode_lon = postcode_lat_lon[:lon]

        nearest_stops = @tfl_interface.get_nearest_stops(postcode_lat, postcode_lon)

        @bus_stop_arrivals_infos = nearest_stops[0, 2]
                                     .map { |stop| get_stop_arrival_info(stop)}
      else
        @postcode_error_msg = "Please enter a valid postcode"
      end
    end
  end

  private

  def get_stop_arrival_info(stop)
    stop_name = stop["commonName"]
    arrivals = @tfl_interface.get_all_arrivals(@tfl_interface.get_stop_ids(stop))
    arrivals.sort_by! { |arrival| arrival[:mins_to_arrive] }
    arrivals_info = BusStopArrivalsInfo.new(stop_name: stop_name)
    arrivals_info.bus_arrivals = arrivals[0, 5]
    arrivals_info
  end

end
