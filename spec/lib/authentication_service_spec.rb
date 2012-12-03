require 'spec_helper'
require 'authentication_service'
require 'poulpe_authentication_client'

describe AuthenticationService do
  let(:authenticator) { stub(PoulpeAuthenticationClient).as_null_object }
  describe "#authenticate" do

    let(:username) { "admin" }
    let(:password) { "admin" }
    let(:first_name) { "firstn" }
    let(:last_name) { "lastn" }
    let(:url) { "http://poulpe.test/authenticate" }
    let(:hash) { "21232f297a57a5a743894a0e4a801fc3" }


    context "authentication success" do
      before do
        PoulpeAuthenticationClient.stub(:new).and_return(authenticator)
        authenticator.stub(:authenticate).and_return(true)
        authenticator.stub(:first_name).and_return(first_name)
        authenticator.stub(:last_name).and_return(last_name)
        CONFIG.stub(:[]).with("poulpe_url").and_return(url)
      end

      it "reads url from config file" do
        CONFIG.should_receive(:[]).with("poulpe_url").and_return(url)
        AuthenticationService.authenticate(username, password)
      end

      it "creates authenticator with hashed password" do
        PoulpeAuthenticationClient.should_receive(:new)
          .with(url, username, hash)
          .and_return(authenticator)

        AuthenticationService.authenticate(username, password)
      end

      context "when user exists" do
        before do
          @existing_user = FactoryGirl.create(:user, username: username, first_name: "lol", last_name: "lol")
        end

        it "doesnt create new user" do
          expect { AuthenticationService.authenticate(username, password) }.not_to change(User, :count)
        end

        it "updates user info" do
          user = AuthenticationService.authenticate(username, password)
          user.first_name.should eq(first_name)
          user.last_name.should eq(last_name)
        end

        it "returns existing user" do
          AuthenticationService.authenticate(username, password).should eq(@existing_user)
        end
      end

      context "when user doesnt exist" do
        it "creates new user" do
          expect { AuthenticationService.authenticate(username, password) }.to change(User, :count).by(1)
        end

        it "fills user info" do
          User.should_receive(:create).with(username: username, first_name: first_name, last_name: last_name)
          AuthenticationService.authenticate(username, password)
        end

        it "returns created user" do
          user = User.new(username: username)
          User.should_receive(:create).and_return(user)
          AuthenticationService.authenticate(username, password).should eq(user)
        end
      end
    end

    context "authentication failure" do
      before do
        PoulpeAuthenticationClient.stub(:new).and_return(authenticator)
        authenticator.stub(:authenticate).and_return(false)
        CONFIG.stub(:[]).with("poulpe_url").and_return(url)
      end

      it "doesnt create new user" do
          expect { AuthenticationService.authenticate(username, password) }.not_to change(User, :count)
      end

      it "returns no user" do
        AuthenticationService.authenticate(username, password).should be_nil
      end
    end
  end
end
