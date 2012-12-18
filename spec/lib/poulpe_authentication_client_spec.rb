require 'webmock/rspec'
require 'poulpe_authentication_client'

describe PoulpeAuthenticationClient do
  before do
    @request_body = "" \
     "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" \
     "<authentication xmlns=\"http://www.jtalks.org/namespaces/1.0\">" \
       "<credentials>" \
        "<username>admin</username>" \
        "<passwordHash>21232f297a57a5a743894a0e4a801fc3</passwordHash>" \
       "</credentials>" \
     "</authentication>"

    @response_body = <<-STR
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <authentication xmlns="http://www.jtalks.org/namespaces/1.0">
          <credentials>
              <username>admin</username>
          </credentials>
          <status>success</status>
          <profile>
              <firstName>admin1</firstName>
              <lastName>admin</lastName>
          </profile>
      </authentication>
    STR

    @response_body_noprofile = <<-STR
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <authentication xmlns="http://www.jtalks.org/namespaces/1.0">
          <credentials>
              <username>admin</username>
          </credentials>
          <status>success</status>
      </authentication>
    STR

    @response_body_failure = <<-STR
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <authentication xmlns="http://www.jtalks.org/namespaces/1.0">
          <credentials>
              <username>failure-user</username>
          </credentials>
          <status>fail</status>
          <statusInfo>Incorrect username or password</statusInfo>
      </authentication>
    STR

    @url = "http://poulpe.test/authenticate"
    @authenticator = PoulpeAuthenticationClient.new(@url, "admin", "21232f297a57a5a743894a0e4a801fc3")
  end

  subject { @authenticator }

  describe ".authenticate" do

    context "success response" do
      context "with profile info" do
        before do
          stub_request(:post, @url)
          .with(body: @request_body)
          .to_return(body: @response_body)
        end

        it "successfully authenticates user" do
          @authenticator.authenticate.should be_true
          WebMock.should have_requested(:post, @url).with(body: @request_body).once
        end

        describe "user info" do
          before do
            @authenticator.authenticate
          end
          it "contains first name" do
            @authenticator.first_name.should eq("admin1")
          end
          it "contains last name" do
            @authenticator.last_name.should eq("admin")
          end
        end
      end

      context "without profile info" do
        before do
          stub_request(:post, @url)
          .with(body: @request_body)
          .to_return(body: @response_body_noprofile)
        end

        it "successfully authenticates user" do
          @authenticator.authenticate.should be_true
          WebMock.should have_requested(:post, @url).with(body: @request_body).once
        end

        describe "user info" do
          before do
            @authenticator.authenticate
          end
          it { @authenticator.first_name.should be_nil }
          it { @authenticator.last_name.should be_nil }
        end
      end
    end

    context "failure response" do
      before do
        stub_request(:post, @url)
          .with(body: @request_body)
          .to_return(body: @response_body_failure)
      end

      it "doesnt authenticate user" do
        @authenticator.authenticate.should be_false
        WebMock.should have_requested(:post, @url).with(body: @request_body).once
      end
    end
  end
end
