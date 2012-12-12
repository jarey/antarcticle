include ApplicationHelper

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end

RSpec::Matchers.define :have_placeholder do |placeholder, *args|
  match do |page|
    page.should have_xpath("//input[@placeholder='#{placeholder}'] | //textarea[@placeholder='#{placeholder}']", args)
  end

  ##TODO
  #failure_message_for_should do |actual|
  #end

  #failure_message_for_should_not do |actual|
  #end

  #description do
  #end
end

def sign_in(user)
  visit signin_path

  fill_in "Username", with: user.username
  fill_in "Password", with: "1234"
  click_button "Sign in"

  #cookies[:remember_token] = user.remember_token
end

def sign_out
  click_link "Sign out"
end
