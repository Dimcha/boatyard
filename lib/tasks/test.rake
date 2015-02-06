desc 'Run tests'
task :test do
  puts `rspec spec/`
end