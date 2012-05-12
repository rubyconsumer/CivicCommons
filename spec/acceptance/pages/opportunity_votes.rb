module CivicCommonsDriver
  module Pages
    class OportunityVotes
      class New
        SHORT_NAME = :new_opportunity_vote
        include Page
        
        has_link :add_option, 'Add another option', :new_opportunity_vote
        has_link :delete_option, 'Delete option', :new_opportunity_vote
        has_button :publish_invalid_vote, 'Publish', :new_opportunity_vote
        
        has_button :publish, 'Publish', :opportunity_vote
        
        
        def has_error?
          has_content? 'There were errors saving this vote.'
        end
        
        def has_options?(num)
          has_selector? '.survey-option', :count => num
        end
      end
      class Show
        SHORT_NAME = :opportunity_vote
        include Page
        
      end
    end
  end
end
