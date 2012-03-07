module CivicCommonsDriver
  module Pages
    class Petition
      SHORT_NAME = :petitions
      LOCATION = '/blog'
      include Page
      
      class New
        SHORT_NAME = :new_petition
        include Page

        has_field :title, 'petition[title]'
        has_wysiwyg_editor_field :description, 'petition_description', :ckeditor
        has_field :resulting_actions, 'petition[resulting_actions]'
        has_field :signature_needed, 'petition[signature_needed]'
        has_field :end_on, 'petition[end_on]'
        
        has_button :start_invalid_petition, 'Publish', :new_petition
        has_button :start_petition, 'Publish', :petition
        
        # has_link(:start_conversation, "Start a Conversation", :accept_responsibilities)
        # has_link :show_add_file_field, "contribution-add-file"
        # has_file_field :contribution_attachment, "conversation[contributions_attributes][0][attachment]"
        # has_button :start_invalid_conversation, "Start My Conversation"

        # def add_contribution_attachment
        #   follow_show_add_file_field_link
        #   attach_contribution_attachment_with_file File.join(attachments_path, 'imageAttachment.png')
        # end
        
        def has_error?
          has_content? 'There were errors saving this petition.'
        end

        # def has_an_error_for? field
        #   case field
        #   when :invalid_link
        #     error_msg = "The link you provided is invalid"
        #   when :attachment_needs_comment
        #     error_msg = 'Sorry! You must also write a comment above when you upload a file.'
        #   end
        #   has_content? error_msg
        # end
      end

      class Show
        SHORT_NAME = :petition
        include Page
        
      end
      # class View
      #   SHORT_NAME = :view_blog_post
      #   include Page
      #   def initialize options
      #     @blog_post = options[:for]
      #   end
      #   def url
      #     "/blog/#{@blog_post.slug}"
      #   end
      # end

    end

  end
end
