class User < ActiveRecord::Base
  attr_accessible :username

  has_many :articles, dependent: :destroy
end
