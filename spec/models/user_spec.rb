require 'spec_helper'

describe User do
  before { @user = User.new(username: "user1") }

  subject { @user }

  it { should respond_to(:username) }
  it { should respond_to(:articles) }
  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin?) }
  it { should respond_to(:comments) }

  specify { should be_valid }
  specify { should_not be_admin }

  context "when username is not present" do
    before { @user.username = nil }
    it { should_not be_valid}
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end
end
