desc "Run all specs, including JS specs"
task :spec_js do |t|
  ENV['__test_js__'] = 'TRUE'
  Rake::Task["spec"].invoke
end
