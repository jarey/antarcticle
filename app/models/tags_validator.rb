class TagsValidator < ActiveModel::Validator
  MAX_LENGTH = 30
  MAX_TAGS = 10

  def validate(article)
    tags = article.tag_list
    if tags.length() > MAX_TAGS
      article.errors.add(:tags, "count can't be more than #{MAX_TAGS}")
    end
    for tag in tags
      if tag.length() > MAX_LENGTH
        article.errors.add(:tags, "can't contain more than #{MAX_LENGTH} characters")
        break
      end
      unless tag =~ /(^[^\.][\p{Word}\d\-#\s\?\+`'\.]+$)|(^\.[\p{Word}\d\-#\s\?\+`'][\p{Word}\d\-#\s\?\+`'\.]*$)/u
        article.errors.add(:tags, "can't contain special characters")
        break
      end
    end
  end
end
