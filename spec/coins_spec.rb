
#
# Specifying lombard
#
# Wed Jul 14 17:44:14 JST 2021
#

require 'spec_helper'


describe Lombard::Coins do

  describe '#normalize' do

    {

      '12d' => [ 12, :d ],
      '1L' => [ 240, :d ],
      '1L3d' => [ 240 + 3, :d ],
      '1/4d' => [ 0.25, :d ],

    }.each do |k, v|

      it "turns #{k.inspect} into #{v.join}" do

        cs = Lombard::Coins.new('var/rota/coins.csv')
        v = Lombard::Value.make(v)

        expect(cs.normalize(v)).to eq(v)
      end
    end
  end
end

