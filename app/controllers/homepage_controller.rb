class HomepageController < ApplicationController
  def show
    @top_rated = TopItem.highest_rated(3)
    @most_visited_conversations = Conversation.get_top_visited(3)
    
    @main_article = Article.main_article
    @sub_articles = Article.sub_articles
  end
end
