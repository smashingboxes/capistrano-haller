require 'net/https'
require 'capistrano'

configuration = if Capistrano::Configuration.respond_to?(:instance) 
  Capistrano::Configuration.instance(:must_exist)
else
  Capistrano.configuration(:must_exist)
end

class HallNotifier
  class HallApiError < StandardError; end
  ROOT_URI = 'https://hall.com'
  ENDPOINT = '/api/1/services/generic/'
  THUMB_URL = 'https://raw.github.com/smashingboxes/capistrano-haller/master/resources/capistrano-logo.png'
  
  attr_accessor :room_key

  def initialize(room_key)
    @room_key = room_key
  end

  def deployed(branch, rails_env)
    post(message_json("Branch #{branch} was deployed to #{rails_env}."))
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
    response = http.request(req)

    unless ['200', '201'].include?(response.code)
      raise HallApiError,
        "Issue communicating with Hall API. Status: #{response.code}"
    end
  end

  def message_json(body)
    { title: "Capistrano Deployment",
      message: body,
      picture: 'http://roots.io/media/logo-capistrano.png'}.to_json
  end
end

configuration.load do
  namespace :hall_notify do
    desc "Notify a hall channel of deployment"
    task :notify_hall_room do
      if not exists?(:hall_room_key) or hall_room_key.empty?
        logger.important("You must set hall_room_key for hall notifications to work!")
      else
        HallNotifier.new(hall_room_key).deployed(branch, rails_env)
      end
    end
    after 'deploy', 'hall_notify:notify_hall_room'
  end
end
