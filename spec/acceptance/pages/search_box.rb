module CivicCommonsDriver
  module Pages
    module SearchBox
      include Page
      include Capybara::DSL

      add_field(:search_field, "q")
      add_button(:search, "Search", :search_results)

      def search_for(term)
        fill_in_search_field_with term
        click_search_button
      end
    end
  end
end
