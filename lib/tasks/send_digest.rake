namespace :scripts do
  desc 'send out the daily digest'
  task :send_digest => :environment do
    DigestService.send_digest
  end
end
