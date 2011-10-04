namespace :ci do
  desc "runs the ci"
  task :travis do

    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
<<<<<<< HEAD
    Rake::Task["spec"].invoke
    Rake::Task["jasmine:headless"].invoke
=======
    Rake::Task["spec_js"].invoke
    Rake::Task["cucumber"].invoke
    Rake::Task["jasmine:ci"].invoke
>>>>>>> 23c48e309a991d6862cf27ce8ea4445248f7ce7d
  end
end
