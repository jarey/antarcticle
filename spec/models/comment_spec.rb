require 'spec_helper'

describe Comment do
  let(:user) { FactoryGirl.create(:user) }
  let(:article) { FactoryGirl.create(:article) }
  before do
    @comment = user.comments.build(content: "Lorem ipsum")
    @comment.article = article
  end

  subject { @comment }

  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:content) }
  it { should respond_to(:article) }
  its(:user) { should == user }
  its(:article) { should == article }

  it { should be_valid }

  describe "content length" do
    context "is normal" do
      before { @comment.content = "a" * 32000 }
      it { should be_valid }
    end
    context "is too long" do
      before { @comment.content = "a" * 32001 }
      it { should_not be_valid }
    end
    context "is empty" do
      before { @comment.content = "" }
      it { should_not be_valid }
    end
    context "is blank" do
      before { @comment.content = "    " }
      it { should_not be_valid }
    end
  end

  context "when user is not present" do
    before { @comment.user = nil }
    it { should_not be_valid }
  end

  context "when article is not present" do
    before { @comment.article = nil }
    it { should_not be_valid }
  end

  describe "order" do
    before do
      @comment2 = user.comments.build(content: "Lorem ipsum")
      @comment2.article = article
      @comment2.created_at = 1.minute.since
      @comment2.save
      @comment.save
    end

    it "should be ascendant by creation date" do
      Comment.all.index(@comment).should < Comment.all.index(@comment2)
    end
  end
end
