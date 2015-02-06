class Route
  attr_reader :from, :to, :distance, :visited
  attr_writer :visited

  def initialize(from, to, distance = 0)
    @from = from
    @to = to
    @distance = distance
    @visited = false
  end

  def connected_routes(routes)
    routes.select { |route| route.from == to && !route.visited }
  end
end