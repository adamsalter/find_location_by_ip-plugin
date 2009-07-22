# FindTimezoneByIp-plugin

class FindLocationByIp
  cattr_accessor :system_dir
  @@system_dir = File.join(RAILS_ROOT, 'public/system')

  attr_accessor :country_code, :country, :city, :latitude, :longtitude, :timezone
  
  def initialize(ip)
    @loc = {}
    geoip_file = File.join(@@system_dir, 'GeoLiteCity.dat')
    @loc[:geoip] = GeoIP.new(geoip_file).city(ip)
    if @loc[:geoip][7] == ""
      # try hostip if maxmind not found
      @loc[:hostip] = query_hostip(ip)
      @country_code = @loc[:hostip]['countryAbbrev']
      @country = @loc[:hostip]['countryName'].titleize
      @city = @loc[:hostip]['name']
      if @loc[:hostip]['ipLocation'].present?
        # if ip location found
        @latitude, @longtitude = @loc[:hostip]['ipLocation']['PointProperty']['Point']['coordinates'].split(',').reverse.map(&:to_f)
      end
    else
      @country_code = @loc[:geoip][2]
      @country = @loc[:geoip][4]
      @city = @loc[:geoip][7]
      @latitude, @longtitude = @loc[:geoip][9], @loc[:geoip][10]
    end
    begin
      tz = Geonames::WebService.timezone @latitude, @longtitude
      @timezone = tz.timezone_id
    rescue Timeout::Error
      #rescue any errors with web services
    end
  end

  private
    def query_hostip(ip)
      require 'open-uri'
      query = open('http://api.hostip.info/?position=true&ip='+ip)
      raise StandardError, Hash.from_xml(query)['HostipLookupResultSet']['featureMember']['Hostip'].inspect
    end

end