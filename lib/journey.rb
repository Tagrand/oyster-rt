require_relative "station"

class Journey
   PENALTY_FARE = 6
   MINIMUM_CHARGE = 1
   INCREMENT = 1

  attr_reader :entry_station, :exit_station

  def initialize(start_station)
    @entry_station = start_station
    @exit_station = nil
  end

  def fare
    return PENALTY_FARE if incomplete?
    MINIMUM_CHARGE + zone_charger
  end

  def end(exit_station)
    @exit_station = exit_station
    self
  end

  def incomplete?
    @entry_station.nil? || @exit_station.nil?
  end

  private
  def zone_charger
   Math.sqrt((exit_station.zone - entry_station.zone)**2) * INCREMENT
  end


end
