desc "Run specs with coverage report"
task :coverage do |t|
  ENV['__test_js__'] = 'TRUE'
  ENV['__test_coverage__'] = 'TRUE'
  Rake::Task["spec"].invoke
end
