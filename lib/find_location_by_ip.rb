# FindTimezoneByIp-plugin
require 'active_support'
require 'geoip'
require 'geonames'

class FindLocationByIp
  cattr_accessor :system_dir
  @@system_dir = File.join(RAILS_ROOT, 'public/system')

  attr_accessor :country_code, :country, :city, :latitude, :longtitude, :timezone, :loc_data
  
  def initialize(ip)
    @loc_data = {}
    geoip_file = File.join(@@system_dir, 'GeoLiteCity.dat')
    @loc_data[:geoip] = GeoIP.new(geoip_file).city(ip)
    if @loc_data[:geoip][7] == ""
      # try hostip if maxmind not found
      @loc_data[:hostip] = query_hostip(ip)
      @country_code = @loc_data[:hostip]['countryAbbrev']
      @country = @loc_data[:hostip]['countryName'].titleize
      @city = @loc_data[:hostip]['name']
      if @loc_data[:hostip]['ipLocation'].present?
        # if ip location found
        @latitude, @longtitude = @loc_data[:hostip]['ipLocation']['pointProperty']['Point']['coordinates'].split(',').reverse.map(&:to_f)
      end
    else
      @country_code = @loc_data[:geoip][2]
      @country = @loc_data[:geoip][4]
      @city = @loc_data[:geoip][7]
      @latitude, @longtitude = @loc_data[:geoip][9], @loc_data[:geoip][10]
    end
    begin
      tz = Geonames::WebService.timezone @latitude, @longtitude
      @timezone = tz.timezone_id
    rescue Timeout::Error, SocketError, Errno::ETIMEDOUT, Errno::ECONNRESET
      #rescue any errors with web services
    end
  end

  private
    def query_hostip(ip)
      require 'open-uri'
      query = open('http://api.hostip.info/?position=true&ip='+ip)
      Hash.from_xml(query)['HostipLookupResultSet']['featureMember']['Hostip']
    end

end