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
          # possible query to decrease number of queries
          # select u.first_name, u.last_name, c.title from contributions cont INNER JOIN conversations c ON cont.conversation_id = c.id INNER JOIN people u ON cont.owner = u.id;
          conversation = Conversation.find hit.result.conversation_id
          if(conversation)
            @conversations[hit.result.conversation_id] = conversation
          end 
        end

        if(hit.result.issue_id)
          issue = Issue.find hit.result.issue_id
          if(issue)
            @issues[hit.result.issue_id] = issue
          end 
        end
      end
    end
  end
end
