class Article < ActiveRecord::Base
  include ApplicationHelper

  attr_accessible :content, :title, :description, :tag_list

  belongs_to :user
  has_many :taggings
  has_many :tags, through: :taggings

  before_save :create_description

  validates :title, presence: true, length: { maximum: 60 }
  validates_presence_of :user_id

  default_scope order: 'articles.created_at DESC'

  def self.tagged_with(name)
    Tag.find_by_name!(name).articles
  end

  def self.tag_counts
    Tag.select("tags.*, count(taggings.tag_id) as count ").
      joins(:taggings).group("taggings.tag_id")
  end

  def tag_list
    tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end

  private
  def create_description
    self.description = helpers.truncate(helpers.strip_tags(markdown_render(self.content)), :length => 300)
  end

  def helpers
    ActionController::Base.helpers
  end
end
