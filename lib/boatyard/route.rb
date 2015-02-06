class Route
  attr_reader :from, :to, :distance
  
  def initialize(from, to, distance = 0)
    @from = from
    @to = to
    @distance = distance
    @traveled = false
  end
end