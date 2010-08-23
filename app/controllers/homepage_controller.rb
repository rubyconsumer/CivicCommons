class HomepageController < ApplicationController
  def show
    @top_rated = TopItem.highest_rated(3)
    @most_visited_conversations = Conversation.get_top_visited(3)
  end
end
