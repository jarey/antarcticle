class Article < ActiveRecord::Base
  include ApplicationHelper

  attr_accessible :content, :title, :description, :tag_list
  acts_as_taggable

  belongs_to :user

  before_save :create_description

  validates :title, presence: true, length: { maximum: 60 }
  validates_presence_of :user_id
  validates_with TagsValidator

  default_scope order: 'articles.created_at DESC'

  def author_name
    user.username
  end

  def self.get_page(page)
    includes(:user, :tags).paginate(page: page, per_page: 10)
  end

  def self.get_page_tagged(page, tags)
    get_page(page).tagged_with(tags)
  end

  private
  def create_description
    self.description = helpers.truncate(helpers.strip_tags(markdown_render(self.content)), :length => 300)
  end

  def helpers
    ActionController::Base.helpers
  end
end
