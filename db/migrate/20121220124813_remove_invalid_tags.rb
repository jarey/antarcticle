class RemoveInvalidTags < ActiveRecord::Migration
  def up
    Article.find_each do |article|
      tags = article.tag_list
      tags = tags.select { |tag| tag.length() <= 30 }
      tags = tags.select { |tag| tag =~ /(^[^\.][\p{Word}\d\-#\s\?\+`'\.]+$)|(^\.[\p{Word}\d\-#\s\?\+`'][\p{Word}\d\-#\s\?\+`'\.]*$)/u }
      tags = tags.take(10)
      article.tag_list = tags
      article.save
    end
  end

  def down
  end
end
