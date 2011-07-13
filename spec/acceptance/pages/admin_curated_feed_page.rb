require File.expand_path(File.dirname(__FILE__) + '/page_object')

class AdminCuratedFeedPage < PageObject

  def fill_in_title(value)
    @page.fill_in('curated_feed_title', :with => value)
  end

  def fill_in_description(value)
    @page.fill_in('curated_feed_description', :with => value)
  end

  def fill_in_item_url(value)
    @page.fill_in('curated_feed_item_original_url', :with => value)
  end

  def edit_item(item)
    @page.click_link('Edit')
  end

  def delete_item(item)
    @page.click_link('Destroy')
  end

  def has_item_link?(feed, item)
    @page.has_link?('Show', href: admin_curated_feed_item_path(feed, 1))
  end

  def submit
    @page.click_on('curated_feed_submit')
  end

  def submit_item
    @page.click_on('curated_feed_item_submit')
  end

end
