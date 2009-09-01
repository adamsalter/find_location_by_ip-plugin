require 'test_helper'

class FindLocationByIpTest < Test::Unit::TestCase
  class << self
    include ActiveSupport::Testing::Declarative
  end
  
  def setup
  end
  
  # Replace this with your real tests.
  test "united states" do
    @loc1 = FindLocationByIp.new('65.55.110.114')
    @loc2 = FindLocationByIp.new('65.55.110.192')
    @loc3 = FindLocationByIp.new('65.55.105.114')
    @loc4 = FindLocationByIp.new('65.55.109.46')
    assert_equal @loc1.country, 'United States'
    assert_equal @loc2.country, 'United States'
    assert_equal @loc3.country, 'United States'
    assert_equal @loc4.country, 'United States'
  end
end
