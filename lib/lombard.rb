
require 'csv'
require 'strscan'

require 'ect'
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

  def to_a(opts={})

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

  def to_table(opts={})

    a = to_a(opts)

    Terminal::Table.new do |ta|

      ta.style = { border_top: false, border_bottom: false }

      ta.headings = [ 'name', 'extra', 'v', 'v' ]

      to_a(opts).each do |e|
        ta << [
          e[:en],
          e[:extra],
          { value: e[:value], alignment: :right },
          { value: e[:nvalue], alignment: :right } ]
      end
    end
  end

  def to_csv(opts={})

    a = to_a(opts)
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

    def to_s

      @a.collect { |e| "#{e[0].to_comma_s}#{e[1]}" }.join
    end

    def *(n)

      Lombard::Value.make(@a.collect { |e| [ n * e[0], e[1] ] })
    end

    def single_number; @a.size == 1 && @a[0][0]; end
    def single_coin; @a.size == 1 && @a[0][1]; end

    class << self

      def make(a)

        a = [ a ] unless a.first.is_a?(Array)

        v = Lombard::Value.allocate
        v.instance_eval { @a = a }

        v
      end
    end
  end

  class Coins

    def initialize(path)

      @data = Csv.load(path)
      @data.each do |e|
        e[:abb] = e[:abb].to_sym
        e[:v0] = Lombard::Value.new(e[:value])
      end

      @pivot = @data.find { |e| e[:value].gsub(/\s+/, '') == "1#{e[:abb]}" }
      @pivot[:v] = @pivot[:v0]
      @pivoc = @pivot[:abb].to_sym

      inflate
#@data.each { |e| p e }
    end

    def normalize(v)

      v = v.is_a?(String) ? Lombard::Value.new(v) : v

      v.to_a
        .collect { |e|
          lookup(e[1])[:v] * e[0] }
        .inject([ 0, nil ]) { |a, v|
          a[0] = a[0] + v.single_number
          a[1] ||= v.single_coin
          a }
        .deflect { |a|
          Lombard::Value.make([ a ]) }
    end

    protected

    def lookup(c); @data.find { |e| e[:abb] == c }; end

    def inflate

      es = @data.select { |e| ! e[:v] }; return if es.empty?

      es.each do |e|
        next if e[:v0].to_a.find { |ee| ! lookup(ee[1])[:v] }
        e[:v] = normalize(e[:v0])
      end

      inflate
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

class Integer

  def to_comma_s

    #to_s.reverse.scan(/\d{1,3}/).join("'").reverse
    to_s.reverse.scan(/\d{1,3}/).join(',').reverse
  end
end

class Float

  def to_comma_s

    to_i.to_comma_s + '.' + to_s.split('.').last
  end
end

