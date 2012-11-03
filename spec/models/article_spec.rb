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
  it { should respond_to(:created_at) }
  its(:user) { should == user }

  it { should be_valid}

  describe "title length" do
    describe "is too long" do
      before { @article.title = "a" * 150 }
      it { should_not be_valid }
    end
    describe "is zero" do
      before { @article.title = "" }
      it { should_not be_valid }
    end
  end

  describe "when user is not present" do
    before { @article.user_id = nil }
    it { should_not be_valid }
  end

  #describe "acessible attributes" do
  #  it "should not allow access to user_id" do
  #    expect do
  #      Article.new(user_id: user.id)
  #    end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
  #  end
  #end
end
