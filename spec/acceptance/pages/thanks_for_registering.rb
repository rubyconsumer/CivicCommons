module CivicCommonsDriver
  class ThanksForRegistering
    SHORT_NAME = :thanks_for_registering
    include Page
    def for? page
      current_path.include? "/people/verification"
    end
  end
end
