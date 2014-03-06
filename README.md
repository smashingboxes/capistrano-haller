# Capistrano Haller

Notifies team members by posting to your hall channel when you deploy your code.

### Installation

Gemfile
``` ruby
  gem 'capistrano-haller', require: false
```

`bundle install`

deploy.rb
``` ruby
  require 'capistrano/haller'
  set :hall_room_key, 'xxx'
  set :hall_message, "Branch #{branch} was deployed to #{rails_env}." #optional
```

Test
`cap hall_notify:notify_hall_room`

The `hall_notify:notify_hall_room` will run after `deploy`.

##### Warning
master is not stable!

### Contributing and Support

Please use GH issues for bug reports and feature requests.

To contribute, fork and submit a pull request.

### Compatability

This plugin is intended for Capistrano version 2.x, and is meant to run in rails deploy scripts.  However, it should work in capistrano script that sets the `branch` and `rails_env` variables.

### License

MIT

See `LICENSE`
