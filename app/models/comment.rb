class Comment < ActiveRecord::Base
  attr_accessible :content

  validates_presence_of :content
  validates_length_of :content, within: 1..3000
  validates_presence_of :user_id
  validates_presence_of :article_id

  #TODO avoid extra fetching
  default_scope includes(:user, :article).order('comments.created_at ASC')

  belongs_to :user
  belongs_to :article
end
