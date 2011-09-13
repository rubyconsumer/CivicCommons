class SearchController < ApplicationController
  def results

    search_service = SearchService.new

    if params[:filter]
      models_to_search = determine_model_class(params[:filter])
    else
      models_to_search = [Conversation, Issue, Person, Contribution, ContentItem]
    end

    @results = search_service.fetch_results(params[:q], models_to_search).paginate(page: params[:page], per_page: 10)

    # gets the conversation or issue based on id so that the name can be displayed in the view
    @conversations = {}
    @issues = {}

    @results.each do |hit|
      case hit.result
      when Contribution
        if(hit.result.conversation_id)
          @conversations[hit.result.conversation_id] = [hit.result.conversation, hit.result.person]
        end

        if(hit.result.issue_id)
          issue = hit.result.issue
          if(issue)
            @issues[hit.result.issue_id] = [hit.result.issue, hit.result.person]
          end 
        end
      end
    end
  end

  def determine_model_class(model_string)
    case model_string
    when "contributions"
      return Contribution
    when "conversations"
      return Conversation
    when "community"
      return Person
    when "issues"
      return Issue
    end
  end
end
