require "spec_helper"

describe "Tags" do
  subject { page }

  before do
    @article1 = FactoryGirl.create(:article, tag_list: "tag1, tag2")
    @article2 = FactoryGirl.create(:article, tag_list: "tag2")
    @article3 = FactoryGirl.create(:article, tag_list: "tag1")
  end

  context "single tag" do
    describe "opened page with tag 'tag1'" do
      let(:tag) { 'tag1' }
      before do
        visit tag_path(tag)
      end

      it "should contain tag name" do
        should have_selector('li', text: tag)
      end

      it "should show articles tagged with 'tag1'" do
        should have_content(@article1.title)
        should have_content(@article3.title)
      end

      it "should not show article without tag 'tag1'" do
        should_not have_content(@article2.title)
      end
    end
  end

  context "multiple tags" do
    let(:tags) { 'tag1, tag2' }
    before do
      visit tag_path(tags)
    end

    it "should contain tags names" do
      should have_selector('li', text: 'tag1')
      should have_selector('li', text: 'tag2')
    end

    it "should show articles tagged with 'tag1' and 'tag2'" do
      should have_content(@article1.title)
    end

    it "should not show articles without 'tag1' or 'tag2'" do
      should_not have_content(@article2.title)
      should_not have_content(@article3.title)
    end
  end
end
