require_relative "../lib/studip.rb"
require "test/unit"

class TestLogin < Test::Unit::TestCase
  def test_failed_login
    #This should fail...
    assert_raise LoginFailed do 
      Studip.new "http://elearning.uni-bremen.de", "test", "testpw"
    end
  end
end
