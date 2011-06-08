class AddEmbedTargetToArticles < ActiveRecord::Migration
  def self.up
    add_column    :articles,       :embed_target,   :string,   :limit=>1000
    change_column :contributions,  :embed_target,   :string,   :limit=>1000
    Article.homepage_main_article.each do |article|
      article.embed_youtube_video
      article.save
    end
  end

  def self.down
    remove_column :articles, :embed_target
  end
end
