require 'spec_helper'

describe User do
  before { @user = User.new(username: "user1") }

  subject { @user }

  it { should respond_to(:username) }
  it { should respond_to(:articles) }

  it { should be_valid }

  describe "when username is not present" do
    before { @user.username = nil }
    it { should_not be_valid}
  end
end
