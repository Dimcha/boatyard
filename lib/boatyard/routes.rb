class Routes
  def initialize(routes)
    @routes = []
    @all_trips = []

    routes.scan(/[a-zA-Z]{2}\d+/).each do |route|
      @routes << Route.new(route[0], route[1], route[2..-1].to_i)
    end

    find_all_trips
  end

  def get_distance(*suburbs)
    return NO_ROUTE if suburbs.empty?

    route = @all_trips.select { |trip| trip.path == suburbs.join }.first

    route ? route.distance : NO_ROUTE
  end

  def trips_with_max_stops(from, to, max_stops = 10)
    @all_trips.select do |trip|
      trip.path.start_with?(from) && trip.path.end_with?(to) && trip.stops <= max_stops
    end.size
  end

  private

  def find_all_trips
    @routes.each do |route|
      # direct trips
      path = route.from + route.to
      distance = route.distance
      stops = 1
      route.visited = true

      add_trip(Trip.new(path.dup, distance, stops))

      # all other trips
      find_other_trips(route, path.dup, distance, stops)
      route.visited = false
    end
  end

  def find_other_trips(old_route, path, distance, stops)
    old_route.connected_routes(@routes).each do |route|
      path << route.to
      distance += route.distance
      stops += 1
      route.visited = true

      add_trip(Trip.new(path.dup, distance, stops))

      find_other_trips(route, path.dup, distance, stops)
      route.visited = false
    end
  end

  def add_trip(trip)
    return unless @all_trips.select { |t| t.path == trip.path }.empty?

    @all_trips << trip
  end
end
