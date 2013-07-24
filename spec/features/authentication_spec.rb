require 'spec_helper'

describe "Authentication" do
  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_placeholder('Username') }
    it { should have_placeholder('Password') }
    it { should have_button('Sign in') }
  end

  describe "sign in" do
    before { visit signin_path }
    let(:user) { FactoryGirl.create(:user) }

    context "with valid credentials" do
      before do
        fill_in "Username", with: user.username
        fill_in "Password", with: "1234"
        click_button "Sign in"
      end

      it { should_not have_link('Sign in', href: signin_path) }
      it { should have_content("Welcome, #{user.username}")}
      it { should have_link('Sign out', href: signout_path) }

      it "shows success message" do
        should have_selector('div.alert.alert-success', text: "You have successfully signed in!")
      end

      it "redirects to root" do
        current_path.should == root_path
      end
    end

    context "with invalid credentials" do
      let(:invalid_username) { "fwwgwgqgwe" }
      before do
        fill_in "Username", with: invalid_username
        click_button "Sign in"
      end

      it { should have_link('Sign in', href: signin_path) }
      it { should_not have_content("Welcome, ")}
      it "shows error" do
        should have_error_message('Incorrect')
      end
      it "saves username" do
        should have_placeholder 'Username', value: invalid_username
      end
    end
  end

  describe "sign out" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      click_link 'Sign out'
    end

    it { should_not have_link('Sign out', href: signout_path) }
    it { should have_link('Sign in', href: signin_path)}

    it "shows message" do
      should have_selector('div.alert.alert-info', text: "You are now signed out")
    end

    it "redirects to root" do
      current_path.should == root_path
    end
  end
end
