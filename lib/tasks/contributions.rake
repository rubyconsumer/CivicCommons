require "highline/import"
include ActionView::Helpers::TextHelper
include ActionView::Helpers::TagHelper

namespace :contribution do
  desc "Convert contribution content to use html tags instead of relying on simple_format"
  task :update_content => :environment do
    say 'starting contribution conversation'

    contributions = Contribution.find(:all)
    successful_contributions = failed_contributions = []
    contributions_size = contributions.size

    contributions.each_with_index do |contribution, i|
      contribution.content = simple_format(contribution.content).to_s.gsub('<p><p>', '<p>').gsub('</p></p>', '</p>')
      failed_contributions << contribution unless contribution.save
      puts "#{ i + 1 } of #{ contributions_size } completed" if i % 100 == 99
    end

    say 'converstion complete!'
    say "#{ successful_contributions.size - failed_contributions.size } successful contributions"
    say "#{ failed_contributions.size } failed contributions: #{ failed_contributions.collect { |contribution| contribution.id } }"
  end
end