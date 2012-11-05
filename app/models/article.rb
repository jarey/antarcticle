class Article < ActiveRecord::Base
  attr_accessible :content, :title

  belongs_to :user

  validates :title, presence: true, length: { maximum: 60 }
  validates_presence_of :user_id

  default_scope order: 'articles.created_at DESC'
end
