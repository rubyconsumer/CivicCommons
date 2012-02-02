module CivicCommonsDriver
  module Pages
    class Admin
      class BlogPost
        SHORT_NAME = :admin_blog_posts
        include Page

        add_link_for(:edit, "Edit", :admin_blog_show_edit)

        has_button(:update_blogpost_descriptions, "Update BlogPost Descriptions", :admin_blog_posts)
        has_field(:description_long, "Description long")

        def fill_in_blog_post_descriptions_with details
          details = defaults.merge(details)
          fill_in_description_long_with details[:description_long]
        end

        def defaults
          {
            :description_long => 'long description'
          }
        end

        class Edit
          SHORT_NAME = :admin_blog_show_edit
          include Page
          has_field(:page_title, "Page Title")
          has_field(:meta_description, "Page Description")
          has_field(:meta_tags, "Page Meta Tags")
          has_button(:update_content_item, "Update Content item")
        end

      end
    end
  end
end
