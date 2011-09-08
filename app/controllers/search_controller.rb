class SearchController < ApplicationController
  def results

    @conversations = Array.new
    @issues = Array.new
    @community = Array.new

    search_service = SearchService.new
    @results = search_service.fetch_results(params[:q], Conversation, Issue, Person, Contribution).paginate(page: params[:page], per_page: 10)


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
end
