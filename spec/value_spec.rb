
#
# Specifying lombard
#
# Wed Jul 14 16:14:57 JST 2021
#

require 'spec_helper'


describe Lombard::Value do

  describe '.new' do

    {

      '1d' => [ [ 1, :d ] ],
      ' 1d ' => [ [ 1, :d ] ],
      ' 1 d ' => [ [ 1, :d ] ],
      '0.50d' => [ [ 0.5, :d ] ],
      '1/2d' => [ [ 0.5, :d ] ],
      '12d' => [ [ 12, :d ] ],
      '10 * 12d' => [ [ 120, :d ] ],
      '11l12s14d' => [ [ 11, :l ], [ 12, :s ], [ 14, :d ] ],

      '/1d' => ArgumentError,

    }.each do |k, v|

      if v.class == Class

        it "fails at parsing #{k.inspect}" do

          expect { Lombard::Value.new(k) }.to raise_error(v)
        end

      else

        it "parses #{k.inspect} to #{v.inspect}" do

          expect(Lombard::Value.new(k).to_a).to eq(v)
        end
      end
    end
  end

  describe '#/(v)' do

    {

      [ '120d', '6d' ] => 20,
      [ '3d', '6d' ] => 0.5,

    }.each do |(k0, k1), v|

      it "computes #{k0} / #{k1} as #{v}" do

        v0 = Lombard::Value.new(k0)
        v1 = Lombard::Value.new(k1)

        expect(v0 / v1).to eq(v)
      end
    end
  end
end

