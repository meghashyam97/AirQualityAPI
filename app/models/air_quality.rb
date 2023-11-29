class AirQuality < ApplicationRecord
	validates :aqi, :pollutant_concentration, :timestamp, presence: true
	belongs_to :location
end
