
#
# Specifying lombard
#
# Wed Jul 14 16:13:17 JST 2021
#

#require 'pp'
#require 'ostruct'

require 'lombard'


module Helpers
end # Helpers

RSpec.configure do |c|
  c.alias_example_to(:they)
  c.alias_example_to(:so)
  c.include(Helpers)
end

