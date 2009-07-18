# Include hook code here

require 'find_timezone_by_ip'

Rails::Configuration.send(:gem, 'graticule')
Rails::Configuration.send(:gem, 'geonames')
