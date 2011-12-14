module CivicCommonsDriver
  module Page
    include Capybara::DSL

    def self.included(base)
      base.extend(Page)
      if base.constants.include? :SHORT_NAME
        CivicCommonsDriver.available_pages[base::SHORT_NAME] = base
      end
    end

    def goto
      visit url
    end

    def url
      self.class::LOCATION
    end

    def has_wysiwyg_editor_field(field, locator)
      define_method "fill_in_#{field}_with" do | value |
        begin
          page.execute_script("tinymce.get('#{locator}').setContent('#{value}')")
        rescue Capybara::NotSupportedByDriverError
          fill_in locator, :with=>value
        end
      end
    end
    alias :add_wysiwyg_editor_field :has_wysiwyg_editor_field

    def has_field(field, locator)
      define_method "fill_in_#{field}_with" do | value |
        fill_in locator, :with=> value
      end

      define_method "#{field}_field" do
        find_field locator
      end
    end
    alias :add_field :has_field

    def has_file_field(field, locator)
      define_method "attach_#{field}_with_file" do | value |
        file_path = value
        attach_file(locator, File.expand_path(file_path))
      end

      define_method "#{field}_file_field" do
        find_field locator
      end

    end
    alias :add_file_field :has_file_field

    def has_checkbox(field, locator)
      define_method "uncheck_#{field}" do
        uncheck locator
      end
      define_method "check_#{field}" do
        check locator
      end
      define_method "#{field}_checkbox" do
        find_field locator
      end
    end

    def has_link_for(name, locator, resulting_page=:current)
      define_method "follow_#{name}_link_for" do | item |
        within item.container do
          follow_link locator, resulting_page
        end
      end
    end
    alias :add_link_for :has_link_for
    def follow_link locator, resulting_page, options={}
      click_link locator
      set_current_page_to resulting_page, options
    end
    def has_link(name, locator, resulting_page=:current)
      define_method "follow_#{name}_link" do |options={}|
        follow_link locator, resulting_page, options
      end
      define_method "#{name}_link" do
        find_link locator
      end
    end
    alias :add_link :has_link
    def has_button(name, locator, resulting_page=:current)
      define_method "click_#{name}_button" do
        wait_until { send("#{name}_button").visible? }
        click_button "#{locator}"
        set_current_page_to resulting_page
      end
      define_method "#{name}_button" do
        find_button locator
      end
    end
    alias :add_button :has_button

    def accept_alert
      page.driver.browser.switch_to.alert.accept
    end

    def set_current_page_to page, options={}
      CivicCommonsDriver.set_current_page_to page, options
    end

    def attachments_path
      File.expand_path(File.dirname(__FILE__) + '/attachments')
    end

    def equal?(page_name)
      [self.class::SHORT_NAME == page_name,
      current_path.end_with?(url)].all?
    end
  end
end
