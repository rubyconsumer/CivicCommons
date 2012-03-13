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
                
        def has_error?
          has_content? 'There were errors saving this petition.'
        end

      end

      class Show
        SHORT_NAME = :petition
        include Page
        
        has_link(:sign_petition, 'Sign the Petition', :petition)
        has_link(:confirm_sign_petition, 'Yes, sign my name', :petition)
        
      end

    end

  end
end
