module CivicCommonsDriver
  module Pages
    class Actions
      SHORT_NAME = :actions
      include Page
      has_link :suggest_an_action, 'Suggest an Action', :actions
      has_link :write_a_petition, 'Write a Petition', :new_petition
    end
  end
end
