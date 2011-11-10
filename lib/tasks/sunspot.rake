namespace :sunspot do
  namespace :solr do
    desc 'stop the Solr instance and restart Solr afterwards'
    task :restart => :environment do
      if RUBY_PLATFORM =~ /w(in)?32$/
        abort('This command does not work on Windows. Please use rake sunspot:solr:run to run Solr in the foreground.')
      end
      Sunspot::Rails::Server.new.stop
      Sunspot::Rails::Server.new.start
    end
  end
end

