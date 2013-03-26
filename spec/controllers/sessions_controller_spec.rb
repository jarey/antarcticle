require 'spec_helper'

describe SessionsController do

  let(:username) { "user1" }
  let(:password) { "passwd" }

  describe "#new" do
    it "renders new" do
      get :new
      should render_template(:new)
    end
  end

  describe "#create" do
    describe "authentication methods" do
      context "poulpe specified" do
        before do
          CONFIG.stub(:[]).with("poulpe_authentication").and_return(true)
          AuthenticationService.stub(:authenticate)
        end

        it "uses authentication service" do
          AuthenticationService.should_receive(:authenticate).with(username, password)
          post :create, { session: { username: username, password: password } }
        end
      end

      context "poulpe not specified" do
        before do
          CONFIG.stub(:[]).with("poulpe_authentication").and_return(false)
          User.stub(:find_by_username)
        end

        it "uses database directly" do
          User.should_receive(:find_by_username).with(username)
          post :create, { session: { username: username, password: password } }
        end
      end
    end

    context "sucessfull authentication" do
      let(:user) { mock_model(User).as_null_object }

      before do
        CONFIG.stub(:[]).with("poulpe_authentication").and_return(false)
        User.stub(:find_by_username).and_return(user)
        controller.stub(:sign_in)
      end

      it "signs in user" do
        controller.should_receive(:sign_in).with(user)
        post :create, { session: { username: username, password: password } }
      end

      it "sets notice message" do
        post :create, { session: { username: username, password: password } }
        flash[:notice].should_not be_blank
      end

      it "redirects to root" do
        post :create, { session: { username: username, password: password } }
        should redirect_to(root_path)
      end

    end

    context "authentication failure" do
      before do
        CONFIG.stub(:[]).with("poulpe_authentication").and_return(false)
        User.stub(:find_by_username).and_return(nil)
      end

      it "sets error message" do
        post :create, { session: { username: username, password: password } }
        flash[:signin_error].should_not be_blank
      end

      it "re-renders new" do
        post :create, { session: { username: username, password: password } }
        should render_template(:new)
      end

      it "assigns username" do
        post :create, { session: { username: username, password: password } }
        assigns(:username).should be username
      end
    end
  end

  describe "#destroy" do
    before do
      controller.stub(:sign_out)
    end

    it "signs out user" do
      controller.should_receive(:sign_out)
      delete :destroy
    end

    it "redirects to root" do
      delete :destroy
      should redirect_to(root_url)
    end

    it "sets info message" do
      delete :destroy
      flash[:info].should_not be_blank
    end
  end
end
