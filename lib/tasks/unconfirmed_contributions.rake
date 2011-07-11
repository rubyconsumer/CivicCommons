# should be scheduled to run, probably once a week is good
# 0 2 * * 1 cd /path/to/app/current && /usr/bin/rake delete_old_unconfirmed_contributions >> /path/to/app/shared/log/cron.log 2>&1
# ^^ runs this at 2am every Monday morning and outputs to shared/log/cron.log

task :delete_old_unconfirmed_contributions => :environment do
  count = Contribution.delete_old_unconfirmed_contributions
  puts "#{Time.now}: Deleted #{count} unconfirmed contribution(s)."
end
