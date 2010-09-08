class HomepageController < ApplicationController
  def show
    @top_rated = TopItem.highest_rated(3)
    @most_visited_conversations = Conversation.get_top_visited(3)
    
    @main_article = Article.where(:current => true, :main => true).first
    @sub_articles = Article.where("main is not ? AND current = ? ", true, true)
  end
end
