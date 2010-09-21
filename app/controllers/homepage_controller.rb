class HomepageController < ApplicationController
  def show
    @top_rated = TopItem.highest_rated(3)
    @most_visited_conversations = Conversation.get_top_visited(3)
    
    @main_article = Article.homepage_main_article.first
    @sub_articles = Article.homepage_sub_articles.limit(3)
  end
end
