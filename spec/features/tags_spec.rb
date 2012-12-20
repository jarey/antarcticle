require "spec_helper"

describe "Tags" do
  subject { page }

  before do
    @article1 = FactoryGirl.create(:article, tag_list: "tag1, tag2")
    @article2 = FactoryGirl.create(:article, tag_list: "tag2")
    @article3 = FactoryGirl.create(:article, tag_list: "tag1")
  end

  describe "one tag" do
    context "simple one-word" do
      let(:tag) { 'tag1' }
      before do
        visit tag_path(tag)
      end

      it "puts tag in filter" do
        should have_placeholder "Tags filter", text: tag
      end

      it "shows tagged articles" do
        should have_content(@article1.title)
        should have_content(@article3.title)
      end

      it "doesnt show not tagged articles" do
        should_not have_content(@article2.title)
      end
    end
  end

  describe "multiple tags" do
    let(:tags) { 'tag1, tag2' }
    before do
      visit tag_path(tags)
    end

    it "puts tags in filter" do
      should have_placeholder "Tags filter", text: 'tag1,tag2'
    end

    it "shows tagged articles" do
      should have_content(@article1.title)
    end

    it "doesnt show not tagged articles" do
      should_not have_content(@article2.title)
      should_not have_content(@article3.title)
    end
  end
end
