module CivicCommonsDriver
  module Pages
    class ReflectionComment
      class Edit
        SHORT_NAME = :edit_reflection_comment
        include Page
        
        has_field :comment_body, 'reflection_comment_body'
        has_button :update_invalid_comment, 'Leave my Response', :edit_reflection_comment
        has_button :update_comment, 'Leave my Response', :reflection
        
        def has_error?
          has_content? 'There were errors saving this response'
        end
      end
    end

  end
end
