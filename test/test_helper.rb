require 'pp'
require 'rubygems'
require 'test/unit'
require 'active_support/testing/declarative'

RAILS_ROOT = File.join(File.dirname(__FILE__), '..', '..', '..', '..')

require 'find_location_by_ip'