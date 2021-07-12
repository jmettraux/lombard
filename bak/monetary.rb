
require 'yaml'

h = {}
h[:b] = [ 'bezant', 'au', 'bizantius aureus', 7 ]
h[:l] = [ 'pound', 'ag', 'libra', 20 ]
h[:mk] = [ 'mark', 'ag', 'marca', 10 ]
h[:s] = [ 'shilling', 'bz', 'solidus', 1 ]
h[:d] = [ 'pence', 'bz', 'denarius', '12d' ]
#h[:ml] = [ 'pence', 'bz', 'denarius', '12d' ]

puts YAML.dump(h)

