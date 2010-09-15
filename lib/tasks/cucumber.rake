if Rails.env == "test"
  require 'rubygems'
  require 'cucumber'
  require 'cucumber/rake/task'

  Cucumber::Rake::Task.new(:features) do |t|
    t.cucumber_opts = "features --format pretty --tags ~@example"
  end
end
