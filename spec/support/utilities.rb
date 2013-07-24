include ApplicationHelper

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
