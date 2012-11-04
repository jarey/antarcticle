class User < ActiveRecord::Base
  attr_accessible :username

  has_many :articles, dependent: :destroy

  before_save :create_remember_token

  validates_presence_of :username

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
