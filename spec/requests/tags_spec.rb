require "spec_helper"

describe "Tags" do
  subject { page }

  before do
    @article1 = FactoryGirl.create(:article, tag_list: "tag1, tag2")
    @article2 = FactoryGirl.create(:article, tag_list: "tag2")
    @article3 = FactoryGirl.create(:article, tag_list: "tag1, tag2")
  end

  describe "opened page with tag 'tag1'" do
    let(:tag) { Tag.find_by_name('tag1') }
    before do
      visit tag_path(tag)
    end

    it "should contain tag name" do
      should have_content(tag.name)
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
