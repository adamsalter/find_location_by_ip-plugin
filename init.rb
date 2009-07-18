# Include hook code here

Rails::Configuration.send(:gem, 'tzinfo')
Rails::Configuration.send(:gem, 'graticule')
Rails::Configuration.send(:gem, 'geonames')

require 'find_timezone_by_ip'

