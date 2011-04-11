module StubbedHttpRequests
  def stub_contribution_urls
    stub_request(:get, /http:\/\/www\.example\.com.*/).to_return(:body => File.open("#{Rails.root}/test/fixtures/example_link.html"), :status => 200)
    stub_request(:get, "http://www.example.com/this-page-does-not-exist").to_return(:status => 404)
    stub_request(:get, YouTubeable::YOUTUBE_REGEX).to_return(:body => File.open("#{Rails.root}/test/fixtures/example_youtube.html"), :status => 200)
  end
  
  def stub_amazon_s3_request
    stub_request(:any, /http:\/\/s3\.amazonaws\.com\/cc-dev\/attachments/)
    stub_request(:any, /http:\/\/s3\.amazonaws\.com/)
  end

  # This set can be used to mock Embedly calls, but the regex needs more work if we want to mock multiple requests
  def stub_pro_embedly_request
    stub_request(:get, /http:\/\/pro\.embed\.ly/).to_return(:body => File.open("#{Rails.root}/test/fixtures/embedly/youtube.json"), :status => 200)
  end
end
