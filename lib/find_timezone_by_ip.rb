# FindTimezoneByIp-plugin

class FindTimezone
  
  class << self
    attr_accessor :geoip_file
    
    def initialize
      self.geoip_file = File.join(RAILS_ROOT, 'public/system/GeoLiteCity.dat')
    end
    
    def by_ip(ip)
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