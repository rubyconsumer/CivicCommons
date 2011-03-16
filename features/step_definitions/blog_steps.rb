Given /^I am on the blog page$/ do
  Factory.create(:normal_person, id: 9)
  Factory.create(:normal_person, id: 11)
  visit '/blog'
end

Then /^I should see correct links to user profiles$/ do
  within('#ShowContentModule') do
    all('a').each { |a|
      a[:href].should_not match(/^http\:\/\/social\.theciviccommons\.com\/user\/\d+/)
      a[:href].should_not match(/^http\:\/\/socialstaging\.theciviccommons\.com\/user\/\d+/)
      a[:href].should_not match(/^http\:\/\/socialint\.theciviccommons\.com\/user\/\d+/)
    }
  end
end
