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
  end
end
