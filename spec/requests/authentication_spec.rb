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

    describe "with valid credentials" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        # TODO: should work in next capybara version
        #fill_in "Username", with: user.username
        #fill_in "Password", with: "1234"

        fill_in_placeholder "Username", user.username
        fill_in_placeholder "Password", "1234"
        click_button "Sign in"
      end

      it { should_not have_link('Sign in', href: signin_path) }
      it { should have_content("Welcome, #{user.username}")}
      it { should have_link('Sign out', href: signout_path) }
      it { should have_selector('div.alert.alert-success', text: "You have successfully signed in!") }
      it { current_path.should == root_path }
    end

    describe "with invalid credentials" do
      before { click_button "Sign in" }

      it { should have_link('Sign in', href: signin_path) }
      it { should_not have_content("Welcome, ")}
      it { should have_error_message('Incorrect') }
      #it { current_path.should == signin_path }
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
    it { should have_selector('div.alert.alert-info', text: "You are now signed out") }
    it { current_path.should == root_path }
  end
end