module CivicCommonsDriver
  module Pages
    class Admin
      class BlogPost
        SHORT_NAME = :admin_blog_posts
        include Page

        add_link_for(:edit, "Edit", :admin_blog_show_edit)

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
