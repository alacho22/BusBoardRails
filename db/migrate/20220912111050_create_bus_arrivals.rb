class CreateBusArrivals < ActiveRecord::Migration[7.0]
  def change
    create_table :bus_arrivals do |t|
      t.string :line_number
      t.string :destination
      t.integer :mins_to_arrive

      t.timestamps
    end
  end
end
