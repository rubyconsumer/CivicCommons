require "highline/import"
include ActionView::Helpers::TextHelper
include ActionView::Helpers::TagHelper

namespace :contribution do
  desc "Convert contribution content to use html tags instead of relying on simple_format"
  task :update_content => :environment do
    say 'starting contribution conversation'

    failed = []
    successful = []
    unchanged = []
    contributions = Contribution.find(:all)
    contributions_size = contributions.size

    contributions.each_with_index do |contribution, i|
      if contribution.content == format_content(contribution.content)
        unchanged << contribution.id
      elsif contribution.update_attribute('content', format_content(contribution.content))
        successful << contribution.id
      else
        failed << contribution.id
      end
      puts "#{ i + 1 } of #{ contributions_size } completed" if i % 100 == 99
    end

    say 'converstion complete!'
    say "#{ unchanged.size } unchanged"
    say "#{ successful.size } successful: #{ successful }"
    say "#{ failed.size } failed: #{ failed }"
  end

  def format_content(content)
    simple_format(content).to_s.gsub(/\n/, '').gsub(/\<p\>\<p\>/, "<p>").gsub(/\<\/p\>\<\/p\>/, "</p>")
  end
end