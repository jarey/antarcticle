class User < ActiveRecord::Base
  attr_accessible :username, :first_name, :last_name

  has_many :articles, dependent: :destroy

  before_save :create_remember_token

  validates_presence_of :username

  def to_param
    username
  end

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
