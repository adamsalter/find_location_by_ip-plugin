# FindTimezoneByIp-plugin

class FindTimezone
  cattr_accessor :system_dir
  @@system_dir = File.join(RAILS_ROOT, 'public/system')

  class << self

    def by_ip(ip)
      geoip_file = File.join(@@system_dir, 'GeoLiteCity.dat')
      loc = GeoIP.new(geoip_file).city(ip)
      begin
        tz = Geonames::WebService.timezone loc[9], loc[10]
        tz.timezone_id
      rescue
        #rescue any errors with web services
        "UTC"
      end
    end

  end
end