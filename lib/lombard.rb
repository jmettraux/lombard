
require 'csv'
require 'strscan'


class Lombard

  VERSION = '1.0.0'

  LANGS = %i[ en fr la ]

  def initialize(dir)

    @dir = dir

    @coins = Coins.new(File.join(@dir, 'coins.csv'))

    @categories = Dir[File.join(@dir, '*.csv')]
      .reject { |pa|
        pa.match(/\/coins\.csv$/) }
      .inject({}) { |h, pa|
        h[File.basename(pa, '.csv')] = Csv.load(pa)
        h }
    @items = @categories
      .inject({}) { |h, (kat, items)|
        items.each do |item|
          en = item[:en]; next unless en
          item[:kat] = kat
          h[en] = item
        end
        h }
.tap { |x| pp x }
  end

  class Coins

    def initialize(path)

      @data = Csv.load(path)
    end

    class << self

      def parse(s)

        r = []

        ss = StringScanner.new(s)
        loop do
          n = ss.scan(/\d+(\.\d+)?/); break unless n
          c = ss.scan(/[a-zA-Z]{1,2}/)
          r << [ n.index('.') ? n.to_f : n.to_i, c.to_sym ]
        end

        r
      end
    end
  end

  class Csv

    class << self

      def load(path)

        h, *d = ::CSV.read(path)
          .reject(&:empty?)
          .reject { |r| r[0].match(/^\s*#/) }

        d.map { |r|
          r.each_with_index.inject({}) { |hh, (c, i)|
            k = (h[i] || "k#{i}").to_sym
            #hh[k] = c ? c.strip : c
            hh[k] = inflate(k, c)
            hh } }
      end

      protected

      def inflate(k, v)

        case k
        when :value then Coins.parse(v)
        else v.respond_to?(:strip) ? v.strip : v
        end
      end
    end
  end
end

