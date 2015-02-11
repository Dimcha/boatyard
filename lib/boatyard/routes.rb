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
    trips = @all_trips.select do |trip|
      trip.path.start_with?(from) && trip.path.end_with?(to) && trip.stops <= max_stops
    end

    trips.size + same_route_multipe_times(trips, 0, max_stops).size
  end

  def trips_with_stops(from, to, stops = 0)
    trips = @all_trips.select do |trip|
      trip.path.start_with?(from) && trip.path.end_with?(to)
    end

    (trips + same_route_multipe_times(trips, 0, stops)).select { |trip| trip.stops == stops }.size
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
    end

    trips.size + same_route_multipe_times(trips, distance).size
  end

  private

  def find_all_trips
    @routes.each do |route|
      # direct trips
      new_path      = route.from + route.to
      new_distance  = route.distance
      stops         = 1
      route.visited = true

      add_trip(Trip.new(new_path, new_distance, stops))

      # all other trips
      find_other_trips(route, new_path, new_distance, stops)
      route.visited = false
    end
  end

  def find_other_trips(old_route, path, distance, stops)
    old_route.connected_routes(@routes).each do |route|
      new_path      = path + route.to
      new_distance  = distance + route.distance
      new_stops     = stops + 1
      route.visited = true

      add_trip(Trip.new(new_path, new_distance, new_stops))

      find_other_trips(route, new_path, new_distance, new_stops)
      route.visited = false
    end
  end

  def add_trip(trip)
    return unless @all_trips.select { |t| t.path == trip.path }.empty?

    @all_trips << trip
  end

  def round_trips
    @all_trips.select { |trip| trip.path.end_with?(trip.path[0]) }
  end

  def same_route_multipe_times(trips, max_distance = 0, max_stops = 0)
    @valid_trips = []

    trips.each do |trip|
      next unless trip.distance < max_distance || trip.stops < max_stops

      round_trips.each do |sub_trip|
        do_round_trip(trip, sub_trip, max_distance, max_stops)
      end
    end

    @valid_trips
  end

  def do_round_trip(trip, sub_trip, max_distance, max_stops)
    return [] unless valid_round_trip(trip, sub_trip, max_distance, max_stops)

    new_path = trip.path.sub(sub_trip.path[0], sub_trip.path)
    new_trip = Trip.new(new_path, count_distance(trip, sub_trip), count_stops(trip, sub_trip) + 1)

    @valid_trips += [new_trip] if new_trip && @valid_trips.select { |t| t.path == new_path}.empty?
    do_round_trip(new_trip, sub_trip, max_distance, max_stops)
  end

  def count_stops(trip, sub_trip)
    trip.stops + sub_trip.stops - 1
  end

  def count_distance(trip, sub_trip)
    trip.distance + sub_trip.distance
  end

  def valid_round_trip(trip, sub_trip, max_distance, max_stops)
    trip.path.include?(sub_trip.path[0..-2]) && (count_stops(trip, sub_trip) < max_stops || count_distance(trip, sub_trip) < max_distance)
  end
end
