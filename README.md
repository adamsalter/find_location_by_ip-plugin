FindTimezoneByIp Plugin
=======================

Easy way to find the "best guess" timezone for a visitor to your Rails app.

Installation
----------

    ./script/plugin install git://github.com/adamsalter/find_timezone_by_ip-plugin.git

This plugin depends on three gems (config/environment.rb):

    config.gem 'tzinfo'
    config.gem 'geoip'
    config.gem 'geonames'
    
Technically the tzinfo gem is not needed by this plugin, but Rails will get confused by the timezone returned without it. (e.g. 'Australia/Sydney')

You will need to run the rake task to download/update the geoip db at least once:

    rake geoip:update_db

by default the database file is placed in `public/system`, which is also a system dir created by capistrano deploys. (Don't forget to add `public/system` to your .gitignore file so that you don't add the geoip db to your repo)

Useage
-----

    Time.zone = FindTimezone.by_ip(request.env['REMOTE_ADDR'])


In application_controller.rb:

    before_filter :select_timezone
    
    private
      def select_timezone
        Time.zone = FindTimezone.by_ip(request.env['REMOTE_ADDR'])
      end

Notes
-----

1) Caching

The request to find the timezone is making a background request to "geonames.org" so it could be quite slow if you did this on every request.

I personally cache the request for every IP address, and, using my [filestore_expires_in-plugin][fsei-plugin], set the expiry to 1 day. So for any IP address the request is only made at most once per day.

    ip = request.env['REMOTE_ADDR']
    cache_key = "controllers/application/select_timezone-%s" % [ip]

    Time.zone = Rails.cache.fetch(cache_key, :expires_in => 1.day) do
      FindTimezone.by_ip(request.env['REMOTE_ADDR'])
    end

2) TZInfo

The Timezone handling in Rails is a little confusing. Rails ActiveSupport::TimeZone basically comes with basic support, in the way of an offset and reduced list of timezones, but means Rails doesn't handle daylight savings by default. Full support is passed to the TZInfo gem.

... this also means things like the ActionView helper functions like `time_zone_select` don't support the Rails timezone naming if you use the TZInfo naming.

The following does work, but lists all possible TZInfo::Timezones:

    #Example
    @user.time_zone = FindTimezone.by_ip(request.env['REMOTE_ADDR'])
    
    time_zone_select 'user', 'time_zone', nil, :model => TZInfo::Timezone


3) MaxMind GeoIP database

  You can change the position of the maxmind db by creating an initializer in `config/initializers`
  
    FindTimezone.system_dir = #{RAILS_ROOT} + '/my_custom_dir'

  Thanks to Maxmind for a great geoip db. [http://www.maxmind.com](http://www.maxmind.com)

Copyright (c) 2009 Adam @ [Codebright.net][cb], released under the MIT license

[fsei-plugin]:http://github.com/adamsalter/filestore_expires_in-plugin/tree/master
[cb]:http://codebright.net "http://codebright.net"