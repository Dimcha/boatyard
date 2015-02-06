desc 'Start program'
task :run do
  file = ARGV.last

  abort('No or wrong file parameter entered.') unless File.exists?(file)

  routes = Routes.new(File.read(file))

  puts " #1: #{routes.get_distance('A', 'B', 'C')}"
  puts " #2: #{routes.get_distance('A', 'D')}"
  puts " #3: #{routes.get_distance('A', 'D', 'C')}"
  puts " #4: #{routes.get_distance('A', 'E', 'B', 'C', 'D')}"
  puts " #5: #{routes.get_distance('A', 'E', 'D')}"
  puts " #6: #{routes.trips_with_max_stops('C', 'C', 3)}"
  puts " #7: #{routes.trips_with_stops('A', 'C', 4)}"
  puts " #8: #{routes.distance_of_shortest_route('A', 'C')}"
  puts " #9: #{routes.distance_of_shortest_route('B', 'B')}"
  puts "#10: #{routes.trips_with_less_distance('C', 'C', 30)}"
end
