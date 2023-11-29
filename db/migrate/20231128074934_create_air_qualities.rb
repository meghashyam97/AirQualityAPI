class CreateAirQualities < ActiveRecord::Migration[7.1]
  def change
    create_table :air_qualities do |t|
      t.references :location, null: false, foreign_key: true
      t.integer :aqi
      t.json :pollutant_concentration
      t.datetime :timestamp

      t.timestamps
    end
  end
end
