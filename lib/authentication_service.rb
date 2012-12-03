require 'digest/md5'
require 'poulpe_authentication_client'

class AuthenticationService
  def self.authenticate(username, password)
    url = CONFIG["poulpe_url"]
    hash = Digest::MD5.hexdigest(password)
    authenticator = PoulpeAuthenticationClient.new(url, username, hash)

    if authenticator.authenticate
      user = User.find_by_username(username)
      if user
        user.update_attributes!(first_name: authenticator.first_name, last_name: authenticator.last_name)
        user
      else
        User.create(username: username, first_name: authenticator.first_name, last_name: authenticator.last_name)
      end
    end
  end
end
