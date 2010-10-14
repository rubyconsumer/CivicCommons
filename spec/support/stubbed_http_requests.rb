module StubbedHttpRequests
  def stub_contribution_urls
    stub_request(:get, /http:\/\/www\.example\.com.*/).to_return(:body => File.open("#{Rails.root}/test/fixtures/example_link.html"), :status => 200)
    stub_request(:get, "http://www.example.com/this-page-does-not-exist").to_return(:status => 404)
    stub_request(:get, YouTubeable::YOUTUBE_REGEX).to_return(:body => File.open("#{Rails.root}/test/fixtures/example_youtube.html"), :status => 200)
    stub_request(:get, "http://civiccommons.digitalcitymechanics.com/content/cid=5").to_return(:body => File.open("#{Rails.root}/test/fixtures/example_pa.html"), :status => 200)
  end
  def stub_amazon_s3_request
    stub_request(:any, /http:\/\/s3\.amazonaws\.com\/civiccommons\/attachments/)
  end
end