Given /^the necessary Civic Commons admin users$/ do
  Factory.create(:admin_person, first_name: 'Dan', last_name: 'Moulthrop', email: 'danmoulthrop@theciviccommons.com')
  Factory.create(:admin_person, first_name: 'Noelle', last_name: 'Celeste', email: 'noelleceleste@theciviccommons.com')
  Factory.create(:admin_person, first_name: 'Mike', last_name: 'Shafarenko', email: 'mikeshafarenko@theciviccommons.com')
end

Given /^I am on the blog page$/ do
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
