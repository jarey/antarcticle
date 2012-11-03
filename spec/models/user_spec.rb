require 'spec_helper'

describe User do
  before { @user = User.new(username: "user1") }

  subject { @user }

  it { should respond_to(:username) }
  it { should respond_to(:articles) }

  it { should be_valid }
end
