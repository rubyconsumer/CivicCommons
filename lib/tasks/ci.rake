namespace :ci do
  desc "runs the ci"
  task :travis do
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    tasks = { "rake spec_js"=>false, 
              "rake cucumber"=>false }
    ["rake spec_js", "rake cucumber"].each do |cmd, passed|
      
      puts "Starting to run #{cmd}..."
      system("export DISPLAY=:99.0 && bundle exec #{cmd}")
      tasks[cmd] = $?.exitstatus == 0
    end
    raise "build failed!" if tasks.has_value?(false)
  end
end
