require 'spec_helper'

describe SessionsHelper do
  describe "sign in" do
    before do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    it "should be signed in" do
      current_user?(@user).should be_true
      signed_in?.should be_true
    end

    it "should set remember me cookie" do
      cookies[:remember_token].should be @user.remember_token
    end
  end

  describe "sign out" do
    it "should sign out user" do
      signed_in?.should be_false
    end

    it "should unset remember me cookie" do
      cookies[:remember_token].should be nil
    end
  end
end
