module CivicCommonsDriver
  module Pages
    class Reflection
      class Show
        SHORT_NAME = :reflection
        include Page
        
        has_field :comment_body, 'reflection_comment_body'
        has_button :create_invalid_comment, 'Leave my Response', :reflection
        has_button :create_comment, 'Leave my Response', :reflection
        
        def has_error?
          has_content? 'There were errors saving this response'
        end
      end

      class Index
        SHORT_NAME = :reflections
        include Page
      end

    end

  end
end
