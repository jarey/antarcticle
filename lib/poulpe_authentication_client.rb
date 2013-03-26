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
    request = create_request(@url, { :username => @username, :passwordHash => @password_hash })
    response = send_request(request)
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
      first_name = XPath.first(xmldoc, "//firstName")
      if first_name
        @first_name = first_name.text
      end
      last_name = XPath.first(xmldoc, "//lastName")
      if last_name
        @last_name = last_name.text
      end
    end
  end

  def send_request(request)
    uri = URI.parse @url
    http = Net::HTTP.new(uri.host, uri.port)
    http.request(request)
  end

  def create_request(url, params)
    require 'uri'
    require 'cgi'
    uri_string = url + "?" + params.map{|k,v| "#{k}=#{CGI::escape(v.to_s)}"}.join('&')
    uri = URI(uri_string)
    Net::HTTP::Get.new(uri.request_uri)
  end
end
