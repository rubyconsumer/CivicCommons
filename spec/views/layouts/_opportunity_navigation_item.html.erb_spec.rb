require 'spec_helper'

describe 'layouts/_opportunity_navigation_item.html.erb' do
  let(:default_locals) do
    {
      active: false,
      title: 'Title',
      link: '#link',
      count: 10
    }
  end

  it "should render local :count" do
    render partial: '/layouts/opportunity_navigation_item', locals: default_locals
    rendered.should =~ /#{default_locals[:count]}/
  end

  it "should render local :title" do
    render partial: '/layouts/opportunity_navigation_item', locals: default_locals
    rendered.should =~ /#{default_locals[:link]}/
  end

  it "should render local :link" do
    render partial: '/layouts/opportunity_navigation_item', locals: default_locals
    rendered.should =~ /#{default_locals[:title]}/
  end

  it "should show active indicator if active" do
    default_locals[:active] = true
    render partial: '/layouts/opportunity_navigation_item', locals: default_locals
    rendered.should =~ /<i class="ico-sm ico-person-white"><\/i>/
  end

  it "should not show active indicator if not active" do
    render partial: '/layouts/opportunity_navigation_item', locals: default_locals
    rendered.should_not =~ /<i class="ico-sm ico-person-white"><\/i>/
  end

  it "should have 'active' class on link if active" do
    default_locals[:active] = true
    render partial: '/layouts/opportunity_navigation_item', locals: default_locals
    rendered.should =~ /^<a class="button secondary active"/
  end

  it "should not have 'active' class on link if not active" do
    render partial: '/layouts/opportunity_navigation_item', locals: default_locals
    rendered.should =~ /^<a class="button secondary"/
  end
end
