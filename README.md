FindTimezoneByIp Plugin
=======================

Easy way to find the "best guess" timezone for a visitor to your Rails app.

Installation
----------

    ./script/plugin install git://github.com/adamsalter/find_timezone_by_ip-plugin.git

This plugin depends on two gems (config/environment.rb):

    config.gem 'graticule'
    config.gem 'geonames'

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

The request to find the timezone is making two background requests to "hostip.info" and "geonames.org" so it could be quite slow if you did this on every request.

I personally cache the request for every IP address, and, using my [filestore_expires_in-plugin][fsei-plugin], set the expiry to 1 day. So for any IP address the request is only made at most once per day.

    cache_key = "controllers\application\select_timezone-%s" % [ip]

    Time.zone = Rails.cache.fetch(cache_key, :expires_in => 1.day) do
      FindTimezone.by_ip(request.env['REMOTE_ADDR'])
    end

Copyright (c) 2009 Adam @ [Codebright.net][cb], released under the MIT license

[fsei-plugin]:http://github.com/adamsalter/filestore_expires_in-plugin/tree/master
[cb]:http://codebright.net "http://codebright.net"