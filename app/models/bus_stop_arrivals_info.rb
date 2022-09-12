class BusStopArrivalsInfo < ApplicationRecord
  has_many :bus_arrivals, dependent: :destroy
end
