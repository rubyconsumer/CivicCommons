class SearchController < ApplicationController
  def results

    search_service = SearchService.new

    if params[:filter]
      models_to_search = determine_model_class(params[:filter])
    else
      models_to_search = [Conversation, Issue, Person, Contribution, ContentItem, ManagedIssuePage]
    end

    if params[:q] == ''
      flash[:error] = 'You did not search for anything.  Please try again.'
      @results = []
    else
      @results = search_service.fetch_results(params[:q], models_to_search).paginate(page: params[:page], per_page: 10)
    end

  end

  private
  def determine_model_class(model_string)
    case model_string
    when "contributions"
      return Contribution
    when "conversations"
      return Conversation
    when "community"
      return Person
    when "issues"
      return [Issue, ManagedIssuePage]
    end
  end
end
