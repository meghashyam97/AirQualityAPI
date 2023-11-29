class Location < ApplicationRecord
    validates :name, :state, :country, presence: true
    has_many :air_qualities, dependent: :destroy
end
