require 'net/http'
require 'rexml/document'

class PoulpeAuthenticationClient
  include REXML

  def initialize(url)
    @url = url
  end

  def authenticate(username, password_hash)
    request = create_request(username, password_hash)
    response = send_request(request)

    xmldoc = Document.new(response.body)
    status = XPath.first(xmldoc, "//status").text

    status == "success"
  end

  private

  def send_request(request)
    uri = URI.parse @url
    http = Net::HTTP.new(uri.host, uri.port)
    http.request(request)
  end

  def create_request(username, password_hash)
    request = Net::HTTP::Post.new(@url)
    request.add_field "Content-Type", "text/xml"
    request.body = compose_request_body(username, password_hash)
    request
  end

  def compose_request_body(username, password_hash)
    <<-STR
     <?xml version="1.0" encoding="UTF-8"?>
     <authentication xmlns="http://www.jtalks.org/namespaces/1.0">
       <credintals>
         <username>#{username}</username>
         <passwordHash>#{password_hash}</passwordHash>
       </credintals>
     </authentication>
    STR
  end

end
