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

    distance = 0

    suburbs.each_with_index do |suburb, i|
      current_route = @routes.select { |route| route.from == suburb && route.to == suburbs[i+1] }.first

      return NO_ROUTE unless current_route || i == suburbs.size - 1

      distance += current_route.distance if current_route
    end

    distance
  end

  def trips_with_max_stops(from, to, max_stops = 10)
    puts @all_trips.inspect

    @all_trips.select do |trip|
      trip.path.start_with?(from) && trip.path.end_with?(to) && trip.stops < max_stops + 1
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

      @all_trips << Trip.new(path, distance, stops)

      # all other trips
      find_other_trips(route, path, distance, stops)
      route.visited = false
    end
  end

  def find_other_trips(old_route, path, distance, stops)
    old_route.connected_routes(@routes).each do |route|
      next if route.visited

      path << route.to
      distance += route.distance
      stops += 1
      route.visited = true

      @all_trips << Trip.new(path, distance, stops)

      find_other_trips(route, path, distance, stops)
      route.visited = false
    end
  end
end
