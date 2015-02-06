class Routes
  def initialize(routes)
    @routes = []

    routes.scan(/[a-zA-Z]{2}\d+/).each do |route|
      @routes << Route.new(route[0], route[1], route[2..-1].to_i)
    end
  end

  def get_distance(*suburbs)
    return NO_ROUTE unless suburbs

    distance = 0

    suburbs.each_with_index do |suburb, i|
      current_route = @routes.select { |route| route.from == suburb && route.to == suburbs[i+1] }.first

      return NO_ROUTE unless current_route || i == suburbs.size - 1

      distance += current_route.distance if current_route
    end

    distance
  end
end
