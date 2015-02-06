class Trip
  attr_reader :path, :distance, :stops

  def initialize(path, distance, stops)
    @path = path
    @distance = distance
    @stops = stops
  end
end
