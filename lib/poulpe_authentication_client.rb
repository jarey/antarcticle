require 'net/http'
require 'rexml/document'

class PoulpeAuthenticationClient
  include REXML

  attr_reader :first_name
  attr_reader :last_name

  def initialize(url, username, password_hash)
    @url = url
    @username = username
    @password_hash = password_hash
  end

  def authenticate
    request = create_request
    response = send_request(request)
    puts response.body
    parse_response(response.body)
    success?
  end

  def success?
    @status == "success"
  end

  private

  def parse_response(response_body)
    xmldoc = Document.new(response_body)
    @status = XPath.first(xmldoc, "//status").text
    if success?
      @first_name = XPath.first(xmldoc, "//firstName").text
      @last_name = XPath.first(xmldoc, "//lastName").text
    end
  end

  def send_request(request)
    uri = URI.parse @url
    http = Net::HTTP.new(uri.host, uri.port)
    http.request(request)
  end

  def create_request
    request = Net::HTTP::Post.new(@url)
    request.add_field "Content-Type", "text/xml"
    request.body = compose_request_body()
    puts request.body
    request
  end

  def compose_request_body
     "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" \
     "<authentication xmlns=\"http://www.jtalks.org/namespaces/1.0\">" \
       "<credintals>" \
        "<username>#{@username}</username>" \
        "<passwordHash>#{@password_hash}</passwordHash>" \
       "</credintals>" \
     "</authentication>"
  end

end
