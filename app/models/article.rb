class Article < ActiveRecord::Base
  attr_accessible :content, :title, :user_id

  belongs_to :user

  validates :title, presence: true, length: { maximum: 60 }
  validates_presence_of :user_id
end
