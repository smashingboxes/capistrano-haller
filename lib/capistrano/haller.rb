require 'capistrano'
require 'haller'

Haller::CAPISTRANO_THUMB_URL =
  'https://raw.github.com/smashingboxes/capistrano-haller/master/resources/capistrano-logo.png'

configuration = if Capistrano::Configuration.respond_to?(:instance)
  Capistrano::Configuration.instance(:must_exist)
else
  Capistrano.configuration(:must_exist)
end

configuration.load do
  namespace :hall_notify do
    desc "Notify a hall channel of deployment"
    task :notify_hall_room do
      if not exists?(:hall_room_key) or hall_room_key.empty?
        logger.important("You must set hall_room_key for hall notifications to work!")
      else
        begin
          Haller.new(hall_room_key,
            sender_icon_url: Haller::CAPISTRANO_THUMB_URL,
            ).send_message( exists?(:hall_message) ? hall_message : "Branch #{branch} was deployed to #{rails_env}.")
        rescue Haller::HallApiError => e
          logger.important("Could not contact hall API for deployment notification.")
        end
      end
    end
    after 'deploy', 'hall_notify:notify_hall_room'
  end
end
