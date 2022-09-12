class CreateBusStopArrivalsInfos < ActiveRecord::Migration[7.0]
  def change
    create_table :bus_stop_arrivals_infos do |t|
      t.string :stop_name
      t.timestamps
    end
  end
end
