include ApplicationHelper
class AddDescriptionToArticles < ActiveRecord::Migration

  def change
    add_column :articles, :description, :text

    # create descriptions by triggering before_save
    Article.all.each do |article|
      article.save
    end
  end
end
