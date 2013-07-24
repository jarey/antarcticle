require 'spec_helper'

describe "navigation menu" do
  subject { page }

  describe "configurable menu" do
    context "entries exists" do
      before do
        @entries = [
          { "name" => "link1", "url" => "http://example1.com"},
          { "name" => "link2", "url" => "http://example2.com"}
        ]
        CONFIG.stub(:[]).and_return(nil)
        CONFIG.should_receive(:has_key?).with("menu").and_return(true)
        CONFIG.should_receive(:[]).with("menu").and_return(@entries)
        visit root_path
      end

      it "shows links from config" do
        @entries.each do |entry|
          find("nav").should have_link(entry["name"], href: entry["url"])
        end
      end
    end

    context "entries not exists" do
      before do
        CONFIG.stub(:[]).and_return(nil)
        CONFIG.should_receive(:has_key?).with("menu").and_return(false)
        visit root_path
      end

      it "should not display menu" do
        find(".navbar").should_not have_css("ul.nav.custom-menu")
      end
    end
  end

  describe "title" do
    context "specified" do
      before do
        CONFIG.stub(:[]).with("title").and_return("Title")
        CONFIG.should_receive(:[]).with("title").and_return("Title")
        visit root_path
      end

      it "shows specified title" do
        find(".brand").should have_content "Title"
      end
    end

    context "not specified" do
      before do
        CONFIG.stub(:[]).and_return(nil)
        visit root_path
      end

      it "shows default title" do
        find(".brand").should have_content "Antarcticle"
      end
    end
  end
end
