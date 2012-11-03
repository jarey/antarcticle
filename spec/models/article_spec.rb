require 'spec_helper'

describe Article do
  let(:user) { FactoryGirl.create(:user) }
  before { @article = user.articles.build(title: "Article title",
                                          content: "Lorem ipsum")}

  subject { @article }

  it { should respond_to(:title) }
  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }

  it { should be_valid}
end
