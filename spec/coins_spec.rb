
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

      '4d2f' => [ 4.5, :d ],
      '2f' => [ 0.5, :d ],

    }.each do |k, v|

      it "turns #{k.inspect} into #{v.join}" do

        cs = Lombard::Coins.new('var/rota/coins.csv')
        kv = Lombard::Value.new(k)
        v = Lombard::Value.make(v)

        expect(cs.normalize(kv)).to eq(v)
      end
    end
  end

  describe '#change' do

    {

      '24d' => '2s',
      '120d' => '1m',
      '1m20s1d' => '1L1m1d',

      '4d2f' => '4d2f',
      '2f' => '2f',
      '0.5d' => '2f',

    }.each do |k, v|

      it "changes #{k} to #{v}" do

        cs = Lombard::Coins.new('var/rota/coins.csv')

        expect(cs.change(k).to_s).to eq(v)
      end
    end
  end
end

