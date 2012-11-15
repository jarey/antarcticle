class Tag < ActiveRecord::Base
  attr_accessible :name
  has_many :taggings
  has_many :articles, through: :taggings

  def to_param
    name
  end
end
