namespace :ci do
  desc "runs the ci"
  task :travis do
    ["rake spec_js", "rake cucumber"].each do |cmd|
      puts "Starting to run #{cmd}..."
      system("export DISPLAY=:99.0 && bundle exec #{cmd}")
      raise "#{cmd} failed!" unless $?.exitstatus == 0
    end
  end
end
