# desc "Explaining what the task does"
# task :find_timezone_by_ip_plugin do
#   # Task goes here
# end

namespace :geoip do
  desc "Download the latest geoip db"
  task :update_db => :environment do
    system_dir = FindLocationByIp.system_dir
    # only download if file changed
    `wget --no-verbose --tries 1 --timestamping --directory-prefix=#{system_dir} http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz`
    `cd #{system_dir} && gunzip -c GeoLiteCity.dat.gz > GeoLiteCity.dat`
  end
end