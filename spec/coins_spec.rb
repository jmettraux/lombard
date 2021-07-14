
#
# Specifying lombard
#
# Wed Jul 14 17:44:14 JST 2021
#

require 'spec_helper'


describe Lombard::Coins do

  describe '#normalize' do

    {

      '12d' => [ 12, 'd' ],
      '1l' => [ 240, 'd' ],

    }.each do |k, v|

      it "turns #{k.inspect} into #{v.join}" do

        cs = Lombard::Coins.new('var/rota/coins.csv')
        v = Lombard::Value.new(k)

        expect(cs.normalize(v)).to eq(v)
      end
    end
  end
end

