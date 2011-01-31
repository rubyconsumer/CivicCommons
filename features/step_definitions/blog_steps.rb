Given /^I am on the blog page$/ do
  visit '/blog'
end

Then /^I should see correct links to user profiles$/ do
  within('#ShowContentModule') do
    all('a').each { |a|
      a[:href].should_not match(/^http\:\/\/theciviccommons\.com\/user\/\d+/)
      a[:href].should_not match(/^http\:\/\/www\.theciviccommons\.com\/user\/\d+/)
    }
  end
end
