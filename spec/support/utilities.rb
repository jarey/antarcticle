include ApplicationHelper

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end

RSpec::Matchers.define :have_placeholder do |placeholder|
  match do |page|
    page.should have_selector("input[placeholder='#{placeholder}'], textarea[placeholder='#{placeholder}']")
  end
end

def fill_in_placeholder(placeholder, value)
  find("input[placeholder='#{placeholder}'], textarea[placeholder='#{placeholder}']").set value
end

def sign_in(user)
  visit signin_path

  fill_in_placeholder "Username", user.username
  fill_in_placeholder "Password", "1234"
  click_button "Sign in"

  cookies[:remember_token] = user.remember_token
end