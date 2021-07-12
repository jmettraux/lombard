
require 'yaml'

h = {}
h[:b] = [ 'bezant', 'au', 'bizantius aureus', 7 ]
h[:l] = [ 'pound', 'ag', 'libra', 20 ]
h[:m] = [ 'mark', 'ag', 'marca', 10 ]
h[:s] = [ 'shilling', 'bz', 'solidus', 1 ]
h[:d] = [ 'pence', 'bz', 'denarius', '12d' ]
#h[:ml] = [ 'maille', 'bz', 'maille', '24ml' ] # half a penny
#h[:f] = [ 'ferlin', 'bz', 'ferlin', '48ml' ] # quarter of a penny

puts YAML.dump(h)

