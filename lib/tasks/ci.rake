namespace :ci do
  desc "runs the ci"
  task :travis do
    ENV['RAILS_ENV'] = 'test'
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["spec"].invoke
    Rake::Task["jasmine:headless"].invoke
  end
end
