require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'redgreen'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'grake'

class Test::Unit::TestCase
  include Grake
end
