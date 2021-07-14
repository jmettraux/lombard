
require 'csv'
require 'strscan'

require 'terminal-table'


class Lombard

  VERSION = '1.0.0'

  LANGS = %i[ en fr la ]

  attr_reader :categories, :items

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
          item[:nvalue] = @coins.normalize(item[:value])
          h[en] = item
        end
        h }
#.tap { |x| pp x }
  end

  def to_a(opts)

    pivot = opts[:pivot] || 'wages'
    kats = opts[:cats]
    sort = opts[:sort] || :en

    @items.values
      .inject([]) { |a, e|
        a << e if (
          kats == nil ||
          kats.include?(e[:kat]) ||
          kats.find { |k| e[:kat].index(k) })
        a }
      .sort_by { |e|
        e[sort] }
  end

  def to_table(opts)
  end
  def to_csv(opts)
  end

  class Coins

    def initialize(path)

      @data = Csv.load(path)

      @data.each do |e|
        m = e[:value].match(/^(\d+)([*\/])?(\d+)?([a-z]{1,2})$/)
        fail ArgumentError.new("cannot make sense of #{e[:value].inspect}") \
          unless m
        @pivot ||= m[4]
        o = m[2] || '*'
        lr = [ m[1], m[3] ].compact
        lr.unshift('1') if lr.size < 2
        l, r = lr[0].to_i, lr[1].to_i
        e[:v] = (o == '*') ? (l * r) : (lr.to_f / r)
      end
@data.each { |e| p e }
p @pivot
    end

    def normalize(value)

      parse_value(value)
    end

    protected

    def parse_value(s)

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

  class Csv

    class << self

      def load(path)

        h, *d = ::CSV.read(path)
          .reject(&:empty?)
          .reject { |r| r[0].match(/^\s*#/) }

        d.map { |r|
          r.each_with_index.inject({}) { |hh, (c, i)|
            k = (h[i] || "k#{i}").to_sym
            hh[k] = c.respond_to?(:strip) ? c.strip : c
            hh } }
      end
    end
  end
end

