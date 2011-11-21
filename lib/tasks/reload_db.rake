namespace :db do
  desc 'reloads database from dropbox'
  task :load_production_data do
    config = Rails.application.config.database_configuration[Rails.env]
    command = "mysql -u#{config['username']} -p#{config['password']} #{config['database']} < ~/Dropbox/Civic\\ Commons/data/db/Core/latest.sql"
    raise 'OMGWTF' unless system(command)
  end
end
