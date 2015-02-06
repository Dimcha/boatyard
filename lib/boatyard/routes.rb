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

  def trips_with_stops(from, to, stops = 0)
    @all_trips.select do |trip|
      trip.path.start_with?(from) && trip.path.end_with?(to) && trip.stops == stops
    end.size
  end

  def distance_of_shortest_route(from, to)
    trips = @all_trips.select do |trip|
      trip.path.start_with?(from) && trip.path.end_with?(to)
    end

    trips ? trips.map(&:distance).min : NO_ROUTE
  end

  def trips_with_less_distance(from, to, distance = 0)
    trips = @all_trips.select do |trip|
      trip.path.start_with?(from) && trip.path.end_with?(to) && trip.distance < distance
    end.size
  end

  private

  def find_all_trips
    @routes.each do |route|
      # direct trips
      new_path = route.from + route.to
      new_distance = route.distance
      stops = 1
      route.visited = true

      add_trip(Trip.new(new_path, new_distance, stops))

      # all other trips
      find_other_trips(route, new_path, new_distance, stops)
      route.visited = false
    end
  end

  def find_other_trips(old_route, path, distance, stops)
    old_route.connected_routes(@routes).each do |route|
      new_path = path + route.to
      new_distance = distance + route.distance
      stops += 1
      route.visited = true

      add_trip(Trip.new(new_path, new_distance, stops))

      find_other_trips(route, new_path, new_distance, stops)
      route.visited = false
    end
  end

  def add_trip(trip)
    return unless @all_trips.select { |t| t.path == trip.path }.empty?

    @all_trips << trip
  end
end
