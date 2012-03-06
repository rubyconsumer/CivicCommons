module CivicCommonsDriver
  module Pages

    class Responsibilities
      SHORT_NAME = :accept_responsibilities
      include Page
      add_link(:agree, "I agree, continue", :start_conversation)
      add_link(:cancel, "cancel", :home)
      def agree_to_responsibilities
        follow_agree_link
      end
    end

  end
end
