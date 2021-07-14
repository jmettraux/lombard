
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

  class Value

    def initialize(s)

      @a = []

      ss = StringScanner.new(s.strip)
      loop do

        l = ss.scan(/\s*[0-9,_]+(\.\d+)?/)
        fail ArgumentError.new("invalid value #{s.inspect}") if ! l && ! ss.eos?
        break unless l

        o = ss.scan(/\s*[*\/]/); o = o && o.strip
        r = ss.scan(/\s*[0-9,_]+(\.\d+)?/)
        c = ss.scan(/\s*[a-zA-Z]{1,2}/).strip

        l = l && l.gsub(/[,_]/, ''); l = l && (l.index('.') ? l.to_f : l.to_i)
        r = r && r.gsub(/[,_]/, ''); r = r && (r.index('.') ? r.to_f : r.to_i)

        v =
          if r
            o == '/' ? (l.to_f / r) : (l * r)
          else
            l
          end

        @a << [ v, c.to_sym ]
      end
    end

    def to_a

      @a
    end

    def ==(other)

      @a == other.to_a
    end

    class << self

      def make(a)

        v = Lombard::Value.allocate
        v.instance_eval { @a = a }

        v
      end
    end
  end

  class Coins

    def initialize(path)

      @data =
        Csv.load(path)
      @pivot =
        @data.find { |e| e[:value].gsub(/\s+/, '') == "1#{e[:abb]}" }
      @pivoc =
        @pivot[:abb].to_sym

      @data.each do |e|
        e[:v] = Lombard::Value.new(e[:value])
      end
@data.each { |e| p e }
print 'pivot: '; p @pivot
    end

    def normalize(value)

      a = value.to_a
        .collect { |e| _normalize(e) }
        .inject([ 0, @pivoc ]) { |a, e| a[0] = a[0] + e[0]; a }

      Value.make([ a ])
    end

    def lookup(c)

      @data.find { |e| e[:abb].to_sym == c }
    end

    protected

    def _normalize(v)

p v
      return v if v[1] == @pivoc
p lookup(v[1])
[ 0, @pivoc ]
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

