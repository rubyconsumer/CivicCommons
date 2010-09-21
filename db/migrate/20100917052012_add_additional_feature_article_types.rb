class AddAdditionalFeatureArticleTypes < ActiveRecord::Migration
  def self.up
    add_column :articles, :homepage_article, :boolean, :default => false
    add_column :articles, :issue_article, :boolean, :default => false
    add_column :articles, :conversation_article, :boolean, :default => false
    change_column_default :articles, :main, false
    change_column_default :articles, :current, false
  end

  def self.down
    remove_column :articles, :homepage_article
    remove_column :articles, :issue_article
    remove_column :articles, :conversation_article
  end
end