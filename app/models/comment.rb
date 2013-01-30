class Comment < ActiveRecord::Base
  attr_accessible :content

  validates_length_of :content, within: 1..3000, allow_blank: false
  validates_presence_of :user_id
  validates_presence_of :article_id

  default_scope order: 'comments.created_at ASC'

  belongs_to :user
  belongs_to :article
end
