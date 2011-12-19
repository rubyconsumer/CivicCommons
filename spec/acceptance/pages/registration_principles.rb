module CivicCommonsDriver
  module Pages
    class RegistrationPrinciples
      SHORT_NAME = :registration_principles
      LOCATION = '/registrations/principles'
      include Page
      
      has_checkbox :agree, 'agree'
      has_link(:continue_as_person, 'continue-as-individual')
      has_link(:continue_as_organization, 'continue-as-organization', :organization_registration_page)
      
      def has_an_error_for? field
        case field
        when :must_agree_to_principles
          error_msg = "You must agree to our principles to register for an account"
        end 
        has_content? error_msg
      end
      
      def agree_to_terms
        check_agree
      end

    end
  end
end