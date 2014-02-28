require 'net/https'
require 'json'

class Haller
  class HallApiError < StandardError; end
  ROOT_URI = 'https://hall.com'
  ENDPOINT = '/api/1/services/generic/'

  OPTION_DEFAULTS = {
    sender_title: 'Haller',
    sender_icon_url: nil}

  attr_accessor :room_key
  attr_accessor :options

  def initialize(room_key, options = {})
    @options = OPTION_DEFAULTS.merge(options)
    @room_key = room_key
  end

  def send_message(message)
    post(message_json(message))
  end

  protected

  def full_path
    ENDPOINT + room_key
  end

  def uri
    URI.parse(ROOT_URI)
  end

  def post(json)
    req = Net::HTTP::Post.new(full_path, {'Content-Type' => 'application/json'})
    req.body = json

    http  = Net::HTTP.new(uri.host, uri.port)
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.use_ssl = true

    begin
      response = http.request(req)
      unless ['200', '201'].include?(response.code)
        raise StandardError, "HTTP Status: #{response.code}"
      end
    rescue StandardError => e
      raise HallApiError, e.message
    end
  end

  def message_json(body)
    { title: options[:sender_title],
      message: body,
      picture: options[:sender_icon_url]}.to_json
  end
end
