class PagesController < ApplicationController



  def initialize
    super
    @postcode_interface = PostcodeInterfaceController.new
    @tfl_interface = TflInterfaceController.new
  end

  def index
    params.require(:postcode)
    params.permit(:postcode)
    postcode = params[:postcode]
    postcode_lat_lon = @postcode_interface.get_postcode_lat_long(postcode)
    postcode_lat = postcode_lat_lon[:lat]
    postcode_lon = postcode_lat_lon[:lon]

    nearest_stops = @tfl_interface.get_nearest_stops(postcode_lat, postcode_lon)
    nearest_stop = nearest_stops[0]
    @nearest_stop_name = nearest_stop["commonName"]
    @nearest_stop_arrivals = @tfl_interface.get_all_arrivals(@tfl_interface.get_stop_ids(nearest_stop))
    @nearest_stop_arrivals.sort_by! { |arrival| arrival[:mins_to_arrive] }
    @nearest_stop_arrivals = @nearest_stop_arrivals[0, 5]

    second_nearest_stop = nearest_stops[1]
    @second_nearest_stop_name = second_nearest_stop["commonName"]
    @second_nearest_stop_arrivals = @tfl_interface.get_all_arrivals(@tfl_interface.get_stop_ids(nearest_stop))
    @second_nearest_stop_arrivals.sort_by! { |arrival| arrival[:mins_to_arrive]}
    @second_nearest_stop_arrivals = @second_nearest_stop_arrivals[0, 5]

  end

end
