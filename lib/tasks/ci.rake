namespace :ci do
  desc "runs the ci"
  task :travis do

    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["spec_js"].invoke
    Rake::Task["cucumber"].invoke
  end
end
