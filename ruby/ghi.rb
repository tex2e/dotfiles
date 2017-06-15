#!/usr/bin/env ruby
# encoding: utf-8
module GHI
  module Commands
    module Version
      MAJOR   = 1
      MINOR   = 2
      PATCH   = 0
      PRE     = nil

      VERSION = [MAJOR, MINOR, PATCH, PRE].compact.join '.'

      def self.execute args
        puts "ghi version #{VERSION}"
      end
    end
  end
end
require 'optparse'

module GHI
  class << self
    attr_reader :current_command

    def execute args
      STDOUT.sync = true
      @current_command = "#{$0} #{args.join(' ')}".freeze

      double_dash = args.index { |arg| arg == '--' }
      if index = args.index { |arg| arg !~ /^-/ }
        if double_dash.nil? || index < double_dash
          command_name = args.delete_at index
          command_args = args.slice! index, args.length
        end
      end
      command_args ||= []

      option_parser = OptionParser.new do |opts|
        opts.banner = <<EOF
usage: ghi [--version] [-p|--paginate|--no-pager] [--help] <command> [<args>]
           [ -- [<user>/]<repo>]
EOF
        opts.on('--version') { command_name = 'version' }
        opts.on '-p', '--paginate', '--[no-]pager' do |paginate|
          GHI::Formatting.paginate = paginate
        end
        opts.on '--help' do
          command_args.unshift(*args)
          command_args.unshift command_name if command_name
          args.clear
          command_name = 'help'
        end
        opts.on '--[no-]color' do |colorize|
          Formatting::Colors.colorize = colorize
        end
        opts.on '-l' do
          if command_name
            raise OptionParser::InvalidOption
          else
            command_name = 'list'
          end
        end
        opts.on '-v' do
          command_name ? self.v = true : command_name = 'version'
        end
        opts.on('-V') { command_name = 'version' }
      end

      begin
        option_parser.parse! args
      rescue OptionParser::InvalidOption => e
        warn e.message.capitalize
        abort option_parser.banner
      end

      if command_name.nil?
        command_name = 'list'
      end

      if command_name == 'help'
        Commands::Help.execute command_args, option_parser.banner
      else
        command_name = fetch_alias command_name, command_args
        begin
          command = Commands.const_get command_name.capitalize
        rescue NameError
          abort "ghi: '#{command_name}' is not a ghi command. See 'ghi --help'."
        end

        # Post-command help option parsing.
        Commands::Help.execute [command_name] if command_args.first == '--help'

        begin
          command.execute command_args
        rescue OptionParser::ParseError, Commands::MissingArgument => e
          warn "#{e.message.capitalize}\n"
          abort command.new([]).options.to_s
        rescue Client::Error => e
          if e.response.is_a?(Net::HTTPNotFound) && Authorization.token.nil?
            raise Authorization::Required
          else
            abort e.message
          end
        rescue SocketError => e
          abort "Couldn't find internet."
        rescue Errno::ECONNREFUSED, Errno::ETIMEDOUT => e
          abort "Couldn't find GitHub."
        end
      end
    rescue Authorization::Required => e
      retry if Authorization.authorize!
      warn e.message
      if Authorization.token
        warn <<EOF.chomp

Not authorized for this action with your token. To regenerate a new token:
EOF
      end
      warn <<EOF

Please run 'ghi config --auth <username>'
EOF
      exit 1
    end

    def config key, options = {}
      upcase = options.fetch :upcase, true
      flags = options[:flags]
      var = key.gsub('core', 'git').gsub '.', '_'
      var.upcase! if upcase
      value = ENV[var] || `git config #{flags} #{key}`
      value = `#{value[1..-1]}` if value.start_with? '!'
      value = value.chomp
      value unless value.empty?
    end

    attr_accessor :v
    alias v? v

    private

    ALIASES = Hash.new { |_, key|
      [key] if /^\d+$/ === key
    }.update(
      'claim'    => %w(assign),
      'create'   => %w(open),
      'e'        => %w(edit),
      'l'        => %w(list),
      'L'        => %w(label),
      'm'        => %w(comment),
      'M'        => %w(milestone),
      'new'      => %w(open),
      'o'        => %w(open),
      'reopen'   => %w(open),
      'rm'       => %w(close),
      's'        => %w(show),
      'st'       => %w(list),
      'tag'      => %w(label),
      'unassign' => %w(assign -d),
      'update'   => %w(edit)
    )

    def fetch_alias command, args
      return command unless fetched = ALIASES[command]

      # If the <command> is an issue number, check the options to see if an
      # edit or show is desired.
      if fetched.first =~ /^\d+$/
        edit_options = Commands::Edit.new([]).options.top.list
        edit_options.reject! { |arg| !arg.is_a?(OptionParser::Switch) }
        edit_options.map! { |arg| [arg.short, arg.long] }
        edit_options.flatten!
        fetched.unshift((edit_options & args).empty? ? 'show' : 'edit')
      end

      command = fetched.shift
      args.unshift(*fetched)
      command
    end
  end
end
module GHI
  module Formatting
    module Colors
      class << self
        attr_accessor :colorize
        def colorize?
          return @colorize if defined? @colorize
          @colorize = STDOUT.tty?
        end
      end

      def colorize?
        Colors.colorize?
      end

      def fg color, &block
        escape color, 3, &block
      end

      def bg color, &block
        fg(offset(color)) { escape color, 4, &block }
      end

      def bright &block
        escape :bright, &block
      end

      def underline &block
        escape :underline, &block
      end

      def blink &block
        escape :blink, &block
      end

      def inverse &block
        escape :inverse, &block
      end

      def highlight(code_block)
        return code_block unless colorize?
        highlighter.highlight(code_block)
      end

      def no_color
        old_colorize, Colors.colorize = colorize?, false
        yield
      ensure
        Colors.colorize = old_colorize
      end

      def to_hex string
        WEB[string] || string.downcase.sub(/^(#|0x)/, '').
          sub(/^([0-f])([0-f])([0-f])$/, '\1\1\2\2\3\3')
      end

      ANSI = {
        :bright    => 1,
        :underline => 4,
        :blink     => 5,
        :inverse   => 7,

        :black     => 0,
        :red       => 1,
        :green     => 2,
        :yellow    => 3,
        :blue      => 4,
        :magenta   => 5,
        :cyan      => 6,
        :white     => 7
      }

      WEB = {
        'aliceblue'            => 'f0f8ff',
        'antiquewhite'         => 'faebd7',
        'aqua'                 => '00ffff',
        'aquamarine'           => '7fffd4',
        'azure'                => 'f0ffff',
        'beige'                => 'f5f5dc',
        'bisque'               => 'ffe4c4',
        'black'                => '000000',
        'blanchedalmond'       => 'ffebcd',
        'blue'                 => '0000ff',
        'blueviolet'           => '8a2be2',
        'brown'                => 'a52a2a',
        'burlywood'            => 'deb887',
        'cadetblue'            => '5f9ea0',
        'chartreuse'           => '7fff00',
        'chocolate'            => 'd2691e',
        'coral'                => 'ff7f50',
        'cornflowerblue'       => '6495ed',
        'cornsilk'             => 'fff8dc',
        'crimson'              => 'dc143c',
        'cyan'                 => '00ffff',
        'darkblue'             => '00008b',
        'darkcyan'             => '008b8b',
        'darkgoldenrod'        => 'b8860b',
        'darkgray'             => 'a9a9a9',
        'darkgrey'             => 'a9a9a9',
        'darkgreen'            => '006400',
        'darkkhaki'            => 'bdb76b',
        'darkmagenta'          => '8b008b',
        'darkolivegreen'       => '556b2f',
        'darkorange'           => 'ff8c00',
        'darkorchid'           => '9932cc',
        'darkred'              => '8b0000',
        'darksalmon'           => 'e9967a',
        'darkseagreen'         => '8fbc8f',
        'darkslateblue'        => '483d8b',
        'darkslategray'        => '2f4f4f',
        'darkslategrey'        => '2f4f4f',
        'darkturquoise'        => '00ced1',
        'darkviolet'           => '9400d3',
        'deeppink'             => 'ff1493',
        'deepskyblue'          => '00bfff',
        'dimgray'              => '696969',
        'dimgrey'              => '696969',
        'dodgerblue'           => '1e90ff',
        'firebrick'            => 'b22222',
        'floralwhite'          => 'fffaf0',
        'forestgreen'          => '228b22',
        'fuchsia'              => 'ff00ff',
        'gainsboro'            => 'dcdcdc',
        'ghostwhite'           => 'f8f8ff',
        'gold'                 => 'ffd700',
        'goldenrod'            => 'daa520',
        'gray'                 => '808080',
        'green'                => '008000',
        'greenyellow'          => 'adff2f',
        'honeydew'             => 'f0fff0',
        'hotpink'              => 'ff69b4',
        'indianred'            => 'cd5c5c',
        'indigo'               => '4b0082',
        'ivory'                => 'fffff0',
        'khaki'                => 'f0e68c',
        'lavender'             => 'e6e6fa',
        'lavenderblush'        => 'fff0f5',
        'lawngreen'            => '7cfc00',
        'lemonchiffon'         => 'fffacd',
        'lightblue'            => 'add8e6',
        'lightcoral'           => 'f08080',
        'lightcyan'            => 'e0ffff',
        'lightgoldenrodyellow' => 'fafad2',
        'lightgreen'           => '90ee90',
        'lightgray'            => 'd3d3d3',
        'lightgrey'            => 'd3d3d3',
        'lightpink'            => 'ffb6c1',
        'lightsalmon'          => 'ffa07a',
        'lightseagreen'        => '20b2aa',
        'lightskyblue'         => '87cefa',
        'lightslategray'       => '778899',
        'lightslategrey'       => '778899',
        'lightsteelblue'       => 'b0c4de',
        'lightyellow'          => 'ffffe0',
        'lime'                 => '00ff00',
        'limegreen'            => '32cd32',
        'linen'                => 'faf0e6',
        'magenta'              => 'ff00ff',
        'maroon'               => '800000',
        'mediumaquamarine'     => '66cdaa',
        'mediumblue'           => '0000cd',
        'mediumorchid'         => 'ba55d3',
        'mediumpurple'         => '9370db',
        'mediumseagreen'       => '3cb371',
        'mediumslateblue'      => '7b68ee',
        'mediumspringgreen'    => '00fa9a',
        'mediumturquoise'      => '48d1cc',
        'mediumvioletred'      => 'c71585',
        'midnightblue'         => '191970',
        'mintcream'            => 'f5fffa',
        'mistyrose'            => 'ffe4e1',
        'moccasin'             => 'ffe4b5',
        'navajowhite'          => 'ffdead',
        'navy'                 => '000080',
        'oldlace'              => 'fdf5e6',
        'olive'                => '808000',
        'olivedrab'            => '6b8e23',
        'orange'               => 'ffa500',
        'orangered'            => 'ff4500',
        'orchid'               => 'da70d6',
        'palegoldenrod'        => 'eee8aa',
        'palegreen'            => '98fb98',
        'paleturquoise'        => 'afeeee',
        'palevioletred'        => 'db7093',
        'papayawhip'           => 'ffefd5',
        'peachpuff'            => 'ffdab9',
        'peru'                 => 'cd853f',
        'pink'                 => 'ffc0cb',
        'plum'                 => 'dda0dd',
        'powderblue'           => 'b0e0e6',
        'purple'               => '800080',
        'red'                  => 'ff0000',
        'rosybrown'            => 'bc8f8f',
        'royalblue'            => '4169e1',
        'saddlebrown'          => '8b4513',
        'salmon'               => 'fa8072',
        'sandybrown'           => 'f4a460',
        'seagreen'             => '2e8b57',
        'seashell'             => 'fff5ee',
        'sienna'               => 'a0522d',
        'silver'               => 'c0c0c0',
        'skyblue'              => '87ceeb',
        'slateblue'            => '6a5acd',
        'slategray'            => '708090',
        'slategrey'            => '708090',
        'snow'                 => 'fffafa',
        'springgreen'          => '00ff7f',
        'steelblue'            => '4682b4',
        'tan'                  => 'd2b48c',
        'teal'                 => '008080',
        'thistle'              => 'd8bfd8',
        'tomato'               => 'ff6347',
        'turquoise'            => '40e0d0',
        'violet'               => 'ee82ee',
        'wheat'                => 'f5deb3',
        'white'                => 'ffffff',
        'whitesmoke'           => 'f5f5f5',
        'yellow'               => 'ffff00',
        'yellowgreen'          => '9acd32'
      }

      private

      def escape color = :black, layer = nil
        return yield unless color && colorize?
        previous_escape = Thread.current[:escape] || "\e[0m"
        escape = Thread.current[:escape] = "\e[%s%sm" % [
          layer, ANSI[color] || escape_256(color)
        ]
        [escape, yield, previous_escape].join
      ensure
        Thread.current[:escape] = previous_escape
      end

      def escape_256 color
        "8;5;#{to_256(*to_rgb(color))}" if supports_256_colors?
      end

      def supports_256_colors?
        `tput colors` =~ /256/
      end

      def to_256 r, g, b
        r, g, b = [r, g, b].map { |c| c / 10 }
        return 232 + g if r == g && g == b && g != 0 && g != 25
        16 + ((r / 5) * 36) + ((g / 5) * 6) + (b / 5)
      end

      def to_rgb hex
        n = (WEB[hex.to_s] || hex).to_i(16)
        [2, 1, 0].map { |m| n >> (m << 3) & 0xff }
      end

      def offset hex
        h, s, l = rgb_to_hsl(to_rgb(WEB[hex.to_s] || hex))
        l < 55 && !(40..80).include?(h) ? l *= 1.875 : l /= 3
        hsl_to_rgb([h, s, l]).map { |c| '%02x' % c }.join
      end

      def rgb_to_hsl rgb
        r, g, b = rgb.map { |c| c / 255.0 }
        max = [r, g, b].max
        min = [r, g, b].min
        d = max - min
        h = case max
          when min then 0
          when r   then 60 * (g - b) / d
          when g   then 60 * (b - r) / d + 120
          when b   then 60 * (r - g) / d + 240
        end
        l = (max + min) / 2.0
        s = if max == min then 0
          elsif l < 0.5   then d / (2 * l)
          else            d / (2 - 2 * l)
        end
        [h % 360, s * 100, l * 100]
      end

      def hsl_to_rgb hsl
        h, s, l = hsl
        h /= 360.0
        s /= 100.0
        l /= 100.0
        m2 = l <= 0.5 ? l * (s + 1) : l + s - l * s
        m1 = l * 2 - m2
        rgb = [[m1, m2, h + 1.0 / 3], [m1, m2, h], [m1, m2, h - 1.0 / 3]]
        rgb.map { |c|
          m1, m2, h = c
          h += 1 if h < 0
          h -= 1 if h > 1
          next m1 + (m2 - m1) * h * 6 if h * 6 < 1
          next m2 if h * 2 < 1
          next m1 + (m2 - m1) * (2.0/3 - h) * 6 if h * 3 < 2
          m1
        }.map { |c| c * 255 }
      end

      def hue_to_rgb m1, m2, h
        h += 1 if h < 0
        h -= 1 if h > 1
        return m1 + (m2 - m1) * h * 6 if h * 6 < 1
        return m2 if h * 2 < 1
        return m1 + (m2 - m1) * (2.0/3 - h) * 6 if h * 3 < 2
        return m1
      end

      def highlighter
        @highlighter ||= begin
          raise unless supports_256_colors?
          require 'pygments'
          Pygmentizer.new
        rescue StandardError, LoadError
          FakePygmentizer.new
        end
      end

      class FakePygmentizer
        def highlight(code_block)
          code_block
        end
      end

      class Pygmentizer
        def initialize
          @style = GHI.config('ghi.highlight.style') || 'monokai'
        end

        def highlight(code_block)
          begin
            indent = code_block['indent']
            lang   = code_block['lang']
            code   = code_block['code']

            if lang != ""
              output = pygmentize(lang, code)
            else
              output = code
            end
            with_indentation(output, indent)
          rescue
            code_block
          end
        end

        private

        def pygmentize(lang, code)
          Pygments.highlight(unescape(code), :formatter => '256', :lexer => lang,
                             :options => { :style => @style })
        end

        def unescape(str)
          str.gsub(/\e\[[^m]*m/, '')
        end

        def with_indentation(string, indent)
          string.each_line.map do |line|
            "#{indent}#{line}"
          end.join
        end
      end
    end
  end
end
# encoding: utf-8
require 'date'
require 'erb'

module GHI
  module Formatting
    class << self
      attr_accessor :paginate
    end
    self.paginate = true # Default.

    attr_accessor :paging
    include Colors

    CURSOR = {
      :up     => lambda { |n| "\e[#{n}A" },
      :column => lambda { |n| "\e[#{n}G" },
      :hide   => "\e[?25l",
      :show   => "\e[?25h"
    }

    THROBBERS = [
      %w(⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏),
      %w(⠋ ⠙ ⠚ ⠞ ⠖ ⠦ ⠴ ⠲ ⠳ ⠓),
      %w(⠄ ⠆ ⠇ ⠋ ⠙ ⠸ ⠰ ⠠ ⠰ ⠸ ⠙ ⠋ ⠇ ⠆ ),
      %w(⠋ ⠙ ⠚ ⠒ ⠂ ⠂ ⠒ ⠲ ⠴ ⠦ ⠖ ⠒ ⠐ ⠐ ⠒ ⠓ ⠋),
      %w(⠁ ⠉ ⠙ ⠚ ⠒ ⠂ ⠂ ⠒ ⠲ ⠴ ⠤ ⠄ ⠄ ⠤ ⠴ ⠲ ⠒ ⠂ ⠂ ⠒ ⠚ ⠙ ⠉ ⠁),
      %w(⠈ ⠉ ⠋ ⠓ ⠒ ⠐ ⠐ ⠒ ⠖ ⠦ ⠤ ⠠ ⠠ ⠤ ⠦ ⠖ ⠒ ⠐ ⠐ ⠒ ⠓ ⠋ ⠉ ⠈),
      %w(⠁ ⠁ ⠉ ⠙ ⠚ ⠒ ⠂ ⠂ ⠒ ⠲ ⠴ ⠤ ⠄ ⠄ ⠤ ⠠ ⠠ ⠤ ⠦ ⠖ ⠒ ⠐ ⠐ ⠒ ⠓ ⠋ ⠉ ⠈ ⠈ ⠉)
    ]

    def puts *strings
      strings = strings.flatten.map { |s|
        s.gsub(/(^| *)@([\w-]+)/) {
          if $2 == Authorization.username
            bright { fg(:yellow) { "#$1@#$2" } }
          else
            bright { "#$1@#$2" }
          end
        }
      }
      super strings
    end

    def page header = nil, throttle = 0
      if paginate?
        pager   = GHI.config('ghi.pager') || GHI.config('core.pager')
        pager ||= ENV['PAGER']
        pager ||= 'less'
        pager  += ' -EKRX -b1' if pager =~ /^less( -[EKRX]+)?$/

        if pager && !pager.empty? && pager != 'cat'
          $stdout = IO.popen pager, 'w'
        end

        puts header if header
        self.paging = true
      end

      loop do
        yield
        sleep throttle
      end
    rescue Errno::EPIPE
      exit
    ensure
      unless $stdout == STDOUT
        $stdout.close_write
        $stdout = STDOUT
        print CURSOR[:show]
        exit
      end
    end

    def paginate?
      ($stdout.tty? && $stdout == STDOUT && Formatting.paginate) || paging?
    end

    def paging?
      !!paging
    end

    def truncate string, reserved
      return string unless paginate?
      space=columns - reserved
      space=5 if space < 5
      result = string.scan(/.{0,#{space}}(?:\s|\Z)/).first.strip
      result << "..." if result != string
      result
    end

    def indent string, level = 4, maxwidth = columns
      string = string.gsub(/\r/, '')
      string.gsub!(/[\t ]+$/, '')
      string.gsub!(/\n{3,}/, "\n\n")
      width = maxwidth - level - 1
      lines = string.scan(
        /.{0,#{width}}(?:\s|\Z)|[\S]{#{width},}/ # TODO: Test long lines.
      ).map { |line| " " * level + line.chomp }
      format_markdown lines.join("\n").rstrip, level
    end

    def columns
      dimensions[1] || 80
    end

    def dimensions
      `stty size 2>/dev/null`.chomp.split(' ').map { |n| n.to_i }
    end

    #--
    # Specific formatters:
    #++

    def format_username username
      username == Authorization.username ? 'you' : username
    end

    def format_issues_header
      state = assigns[:state] ||= 'open'
      org = assigns[:org] ||= nil
      header = "# #{repo || org || 'Global,'} #{state} issues"
      if repo
        if milestone = assigns[:milestone]
          case milestone
            when '*'    then header << ' with a milestone'
            when 'none' then header << ' without a milestone'
          else
            header.sub! repo, "#{repo} milestone ##{milestone}"
          end
        end
        if assignee = assigns[:assignee]
          header << case assignee
            when '*'    then ', assigned'
            when 'none' then ', unassigned'
          else
            ", assigned to #{format_username assignee}"
          end
        end
        if mentioned = assigns[:mentioned]
          header << ", mentioning #{format_username mentioned}"
        end
      else
        header << case assigns[:filter]
          when 'created'    then ' you created'
          when 'mentioned'  then ' that mention you'
          when 'subscribed' then " you're subscribed to"
          when 'all'        then ' that you can see'
        else
          ' assigned to you'
        end
      end
      if creator = assigns[:creator]
        header << " #{format_username creator} created"
      end
      if labels = assigns[:labels]
        header << ", labeled #{labels.gsub ',', ', '}"
      end
      if excluded_labels = assigns[:exclude_labels]
        header << ", excluding those labeled #{excluded_labels.gsub ',', ', '}"
      end
      if sort = assigns[:sort]
        header << ", by #{sort} #{reverse ? 'ascending' : 'descending'}"
      end
      format_state assigns[:state], header
    end

    def format_issues issues, include_repo
      return 'None.' if issues.empty?

      include_repo and issues.each do |i|
        %r{/repos/[^/]+/([^/]+)} === i['url'] and i['repo'] = $1
      end

      nmax, rmax = %w(number repo).map { |f|
        issues.sort_by { |i| i[f].to_s.size }.last[f].to_s.size
      }

      issues.map { |i|
        n, title, labels = i['number'], i['title'], i['labels']
        l = 9 + nmax + rmax + no_color { format_labels labels }.to_s.length
        a = i['assignee']
        a_is_me = a && a['login'] == Authorization.username
        l += a['login'].to_s.length + 2 if a
        p = i['pull_request']['html_url'] and l += 2 if i.key?('pull_request')
        c = i['comments']
        l += c.to_s.length + 1 unless c == 0
        m = i['milestone']
        [
          " ",
          (i['repo'].to_s.rjust(rmax) if i['repo']),
          format_number(n.to_s.rjust(nmax)),
          truncate(title, l),
          (format_labels(labels) unless assigns[:dont_print_labels]),
          (fg(:green) { m['title'] } if m),
          (fg('aaaaaa') { c } unless c == 0),
          (fg('aaaaaa') { '↑' } if p),
          (fg(a_is_me ? :yellow : :gray) { "@#{a['login']}" } if a),
          (fg('aaaaaa') { '‡' } if m)
        ].compact.join ' '
      }
    end

    def extract_milestones_from_issues issues
      return 'None.' if issues.empty?

      nmax, rmax = %w(number repo).map { |f|
        issues.sort_by { |i| i[f].to_s.size }.last[f].to_s.size
      }

      milestones = {}
      extracted_milestones = []
      milestone_index = 0
      issues.map { |i|
        milestone = i['milestone']
        milestone["issues"] = [] if milestone && !(milestones.key? milestone["id"])
        if milestone
          if !milestones.key? milestone["id"]
            milestones.merge!({milestone["id"] => milestone_index })
            i.delete "milestone"
            milestone["issues"] << i
            extracted_milestones << milestone
            milestone_index += 1
          else
            pos_of_existent_milestone = milestones[milestone["id"]]
            i.delete "milestone"
            extracted_milestones[pos_of_existent_milestone]["issues"] << i
          end
        end
      }
      extracted_milestones.sort! { |m1, m2| m1['number'] <=> m2['number'] }
    end

    def format_issues_by_milestone issues, include_repo
      issues_by_milestone = extract_milestones_from_issues issues

      nmax, rmax = %w(number repo).map { |f|
        issues.sort_by { |i| i[f].to_s.size }.last[f].to_s.size
      }

      l = 9 + nmax + rmax

      issues_by_milestone.map { |milestone|
        title =  milestone['title'] if milestone["issues"]
        [
          ("\n  " if milestone["issues"]),
          ("Milestone: " + fg(:green) { truncate(title,l) } if title),
             (format_issues(milestone["issues"], include_repo))
        ].compact
      }
    end

    def format_number n
      colorize? ? "#{bright { n }}:" : "#{n} "
    end

    # TODO: Show milestone, number of comments, pull request attached.
    def format_issue i, width = columns
      return unless i['created_at']
      ERB.new(<<EOF).result binding
<% p = i['pull_request']['html_url'] if i.key?('pull_request') %>\
<%= bright { no_color { indent '%s%s: %s' % [p ? '↑' : '#', \
*i.values_at('number', 'title')], 0, width } } %>
@<%= i['user']['login'] %> opened this <%= p ? 'pull request' : 'issue' %> \
<%= format_date DateTime.parse(i['created_at']) %>. \
<% if i['merged'] %><%= format_state 'merged', format_tag('merged'), :bg %><% end %> \
<%= format_state i['state'], format_tag(i['state']), :bg %> \
<% unless i['comments'] == 0 %>\
<%= fg('aaaaaa'){
  template = "%d comment"
  template << "s" unless i['comments'] == 1
  '(' << template % i['comments'] << ')'
} %>\
<% end %>\
<% if i['assignee'] || !i['labels'].empty? %>
<% if i['assignee'] %>@<%= i['assignee']['login'] %> is assigned. <% end %>\
<% unless i['labels'].empty? %><%= format_labels(i['labels']) %><% end %>\
<% end %>\
<% if i['milestone'] %>
Milestone #<%= i['milestone']['number'] %>: <%= i['milestone']['title'] %>\
<%= " \#{bright{fg(:yellow){'⚠'}}}" if past_due? i['milestone'] %>\
<% end %>
<% if i['body'] && !i['body'].empty? %>
<%= indent i['body'], 4, width %>
<% end %>

EOF
    end

    def format_comments_and_events elements
      return 'None.' if elements.empty?
      elements.map do |element|
        if event = element['event']
          format_event(element) unless unimportant_event?(event)
        else
          format_comment(element)
        end
      end.compact
    end

    def format_comment c, width = columns
      <<EOF
@#{c['user']['login']} commented \
#{format_date DateTime.parse(c['created_at'])}:
#{indent c['body'], 4, width}


EOF
    end

    def format_event e, width = columns
      reference = e['commit_id']
      <<EOF
#{bright { '⁕' }} #{format_event_type(e['event'])} by @#{e['actor']['login']}\
#{" through #{underline { reference[0..6] }}" if reference} \
#{format_date DateTime.parse(e['created_at'])}

EOF
    end

    def format_milestones milestones
      return 'None.' if milestones.empty?

      max = milestones.sort_by { |m|
        m['number'].to_s.size
      }.last['number'].to_s.size

      milestones.map { |m|
        line = ["  #{m['number'].to_s.rjust max }:"]
        space = past_due?(m) ? 6 : 4
        line << truncate(m['title'], max + space)
        line << '⚠' if past_due? m
        percent m, line.join(' ')
      }
    end

    def format_milestone m, width = columns
      ERB.new(<<EOF).result binding
<%= bright { no_color { \
indent '#%s: %s' % m.values_at('number', 'title'), 0, width } } %>
@<%= m['creator']['login'] %> created this milestone \
<%= format_date DateTime.parse(m['created_at']) %>. \
<%= format_state m['state'], format_tag(m['state']), :bg %>
<% if m['due_on'] %>\
<% due_on = DateTime.parse m['due_on'] %>\
<% if past_due? m %>\
<%= bright{fg(:yellow){"⚠"}} %> \
<%= bright{fg(:red){"Past due by \#{format_date due_on, false}."}} %>
<% else %>\
Due in <%= format_date due_on, false %>.
<% end %>\
<% end %>\
<%= percent m %>
<% if m['description'] && !m['description'].empty? %>
<%= indent m['description'], 4, width %>
<% end %>

EOF
    end

    def past_due? milestone
      return false unless milestone['due_on']
      DateTime.parse(milestone['due_on']) <= DateTime.now
    end

    def percent milestone, string = nil
      open, closed = milestone.values_at('open_issues', 'closed_issues')
      complete = closed.to_f / (open + closed)
      complete = 0 if complete.nan?
      i = (columns * complete).round
      if string.nil?
        string = ' %d%% (%d closed, %d open)' % [complete * 100, closed, open]
      end
      string = string.ljust columns
      [bg('2cc200'){string[0, i]}, string[i, columns - i]].join
    end

    def format_state state, string = state, layer = :fg
      color_codes = {
        'closed' => 'ff0000',
        'open'   => '2cc200',
        'merged' => '511c7d',
      }
      send(layer, color_codes[state]) { string }
    end

    def format_labels labels
      return if labels.empty?
      [*labels].map { |l| bg(l['color']) { format_tag l['name'] } }.join ' '
    end

    def format_tag tag
      (colorize? ? ' %s ' : '[%s]') % tag
    end

    def format_event_type(event)
      color_codes = {
        'reopened' => '2cc200',
        'closed' => 'ff0000',
        'merged' => '9677b1',
        'assigned' => 'e1811d',
        'referenced' => 'aaaaaa'
      }
      fg(color_codes[event]) { event }
    end

    #--
    # Helpers:
    #++

    #--
    # TODO: DRY up editor formatters.
    #++
    def format_editor issue = nil
      message = ERB.new(<<EOF).result binding

Please explain the issue. The first line will become the title. Trailing
markdown comments (like these) will be ignored, and empty messages will
not be submitted. Issues are formatted with GitHub Flavored Markdown (GFM):

  http://github.github.com/github-flavored-markdown

On <%= repo %>

<%= no_color { format_issue issue, columns - 2 if issue } %>
EOF
      message.rstrip!
      message.gsub!(/(?!\A)^.*$/) { |line| line.rstrip }
      max_line_len = message.gsub(/(?!\A)^.*$/).max_by(&:length).length
      message.gsub!(/(?!\A)^.*$/) { |line| "<!-- #{line.ljust(max_line_len)} -->" }
      # Adding an extra newline for formatting
      message.insert 0, "\n"
      message.insert 0, [
        issue['title'] || issue[:title], issue['body'] || issue[:body]
      ].compact.join("\n\n") if issue
      message
    end

    def format_milestone_editor milestone = nil
      message = ERB.new(<<EOF).result binding

Describe the milestone. The first line will become the title. Trailing
markdown comments (like these) will be ignored, and empty messages will not be
submitted. Milestones are formatted with GitHub Flavored Markdown (GFM):

  http://github.github.com/github-flavored-markdown

On <%= repo %>

<%= no_color { format_milestone milestone, columns - 2 } if milestone %>
EOF
      message.rstrip!
      message.gsub!(/(?!\A)^.*$/) { |line| line.rstrip }
      max_line_len = message.gsub(/(?!\A)^.*$/).max_by(&:length).length
      message.gsub!(/(?!\A)^.*$/) { |line| "<!-- #{line.ljust(max_line_len)} -->" }
      message.insert 0, [
        milestone['title'], milestone['description']
      ].join("\n\n") if milestone
      message
    end

    def format_comment_editor issue, comment = nil
      message = ERB.new(<<EOF).result binding

Leave a comment. Trailing markdown comments (like these) will be ignored,
and empty messages will not be submitted. Comments are formatted with GitHub
Flavored Markdown (GFM):

  http://github.github.com/github-flavored-markdown

On <%= repo %> issue #<%= issue['number'] %>

<%= no_color { format_issue issue } if verbose %>\
<%= no_color { format_comment comment, columns - 2 } if comment %>
EOF
      message.rstrip!
      message.gsub!(/(?!\A)^.*$/) { |line| line.rstrip }
      max_line_len = message.gsub(/(?!\A)^.*$/).max_by(&:length).length
      message.gsub!(/(?!\A)^.*$/) { |line| "<!-- #{line.ljust(max_line_len)} -->" }
      message.insert 0, comment['body'] if comment
      message
    end

    def format_markdown string, indent = 4
      c = '268bd2'

      # Headers.
      string.gsub!(/^( {#{indent}}\#{1,6} .+)$/, bright{'\1'})
      string.gsub!(
        /(^ {#{indent}}.+$\n^ {#{indent}}[-=]+$)/, bright{'\1'}
      )
      # Strong.
      string.gsub!(
        /(^|\s)(\*{2}\w(?:[^*]*\w)?\*{2})(\s|$)/m, '\1' + bright{'\2'} + '\3'
      )
      string.gsub!(
        /(^|\s)(_{2}\w(?:[^_]*\w)?_{2})(\s|$)/m, '\1' + bright {'\2'} + '\3'
      )
      # Emphasis.
      string.gsub!(
        /(^|\s)(\*\w(?:[^*]*\w)?\*)(\s|$)/m, '\1' + underline{'\2'} + '\3'
      )
      string.gsub!(
        /(^|\s)(_\w(?:[^_]*\w)?_)(\s|$)/m, '\1' + underline{'\2'} + '\3'
      )
      # Bullets/Blockquotes.
      string.gsub!(/(^ {#{indent}}(?:[*>-]|\d+\.) )/, fg(c){'\1'})
      # URIs.
      string.gsub!(
        %r{\b(<)?(https?://\S+|[^@\s]+@[^@\s]+)(>)?\b},
        fg(c){'\1' + underline{'\2'} + '\3'}
      )

      # Inline code
      string.gsub!(/`([^`].+?)`(?=[^`])/, inverse { ' \1 ' })

      # Code blocks
      string.gsub!(/(?<indent>^\ {#{indent}})(```)\s*(?<lang>\w*$)(\n)(?<code>.+?)(\n)(^\ {#{indent}}```$)/m) do |m|
        highlight(Regexp.last_match)
      end

      string
    end

    def format_date date, suffix = true
      days = (interval = DateTime.now - date).to_i.abs
      string = if days.zero?
        seconds, _ = interval.divmod Rational(1, 86400)
        hours, seconds = seconds.divmod 3600
        minutes, seconds = seconds.divmod 60
        if hours > 0
          "#{hours} hour#{'s' unless hours == 1}"
        elsif minutes > 0
          "#{minutes} minute#{'s' unless minutes == 1}"
        else
          "#{seconds} second#{'s' unless seconds == 1}"
        end
      else
        "#{days} day#{'s' unless days == 1}"
      end
      ago = interval < 0 ? 'from now' : 'ago' if suffix
      [string, ago].compact.join ' '
    end

    def throb position = 0, redraw = CURSOR[:up][1]
      return yield unless paginate?

      throb = THROBBERS[rand(THROBBERS.length)]
      throb.reverse! if rand > 0.5
      i = rand throb.length

      thread = Thread.new do
        dot = lambda do
          print "\r#{CURSOR[:column][position]}#{throb[i]}#{CURSOR[:hide]}"
          i = (i + 1) % throb.length
          sleep 0.1 and dot.call
        end
        dot.call
      end
      yield
    ensure
      if thread
        thread.kill
        puts "\r#{CURSOR[:column][position]}#{redraw}#{CURSOR[:show]}"
      end
    end

    private

    def unimportant_event?(event)
      %w{ subscribed unsubscribed mentioned }.include?(event)
    end
  end
end
# encoding: utf-8
require 'socket'

module GHI
  module Authorization
    extend Formatting

    class Required < RuntimeError
      def message() 'Authorization required.' end
    end

    class << self
      def token
        return @token if defined? @token
        @token = GHI.config 'ghi.token'
      end

      def authorize! user = username, pass = password, local = true
        return false unless user && pass
        code ||= nil # 2fa
        args = code ? [] : [54, "✔\r"]
        note = %w[ghi]
        note << "(#{GHI.repo})" if local
        note << "on #{Socket.gethostname}"
        res = throb(*args) {
          headers = {}
          headers['X-GitHub-OTP'] = code if code
          body = {
            :scopes   => %w(public_repo repo),
            :note     => note.join(' '),
            :note_url => 'https://github.com/stephencelis/ghi'
          }
          Client.new(user, pass).post(
            '/authorizations', body, :headers => headers
          )
        }
        @token = res.body['token']

        unless username
          system "git config#{' --global' unless local} github.user #{user}"
        end

        store_token! user, token, local
      rescue Client::Error => e
        if e.response['X-GitHub-OTP'] =~ /required/
          puts "Bad code." if code
          print "Two-factor authentication code: "
          trap('INT') { abort }
          code = gets
          code = '' and puts "\n" unless code
          retry
        end

        if e.errors.any? { |err| err['code'] == 'already_exists' }
          host = GHI.config('github.host') || 'github.com'
          message = <<EOF.chomp
A ghi token already exists!

Please revoke all previously-generated ghi personal access tokens here:

  https://#{host}/settings/tokens
EOF
        else
          message = e.message
        end
        abort "#{message}#{CURSOR[:column][0]}"
      end

      def username
        return @username if defined? @username
        @username = GHI.config 'github.user'
      end

      def password
        return @password if defined? @password
        @password = GHI.config 'github.password'
      end

      private

      def store_token! username, token, local
        if security
          run  = []

          run << security('delete', username)
          run << security('add', username, token)

          find = security 'find', username, false
          run << %(git config#{' --global' unless local} ghi.token "!#{find}")

          system run.join ' ; '

          puts "✔︎ Token saved to keychain."
          return
        end

        command = "git config#{' --global' unless local} ghi.token #{token}"
        system command

        unless local
          at_exit do
            warn <<EOF
Your ~/.gitconfig has been modified by way of:

  #{command}

#{bright { blink { 'Do not check this change into public source control!' } }}

You can increase security by storing the token in a secure place that can be
fetched from the command line. E.g., on OS X:

  git config --global ghi.token \\
    "!security -a #{username} -s github.com -l 'ghi token' -w"

Alternatively, set the following env var in a private dotfile:

  export GHI_TOKEN="#{token}"
EOF
          end
        end
      end

      def security command = nil, username = nil, password = nil
        if command.nil? && username.nil? && password.nil?
          return system 'which security >/dev/null'
        end

        run = [
          'security',
          "#{command}-internet-password",
          "-a #{username}",
          '-s github.com',
          "-l 'ghi token'"
        ]
        run << %(-w#{" #{password}" if password}) unless password.nil?
        run << '>/dev/null 2>&1' unless command == 'find'

        run.join ' '
      end
    end
  end
end
require 'cgi'
require 'net/https'
require 'json'

unless defined? Net::HTTP::Patch
  # PATCH support for 1.8.7.
  Net::HTTP::Patch = Class.new(Net::HTTP::Post) { METHOD = 'PATCH' }
end

module GHI
  class Client

    class Error < RuntimeError
      attr_reader :response
      def initialize response
        @response, @json = response, JSON.parse(response.body)
      end

      def body()    @json             end
      def message() body['message']   end
      def errors()  [*body['errors']] end
    end

    class Response
      def initialize response
        @response = response
      end

      def body
        @body ||= JSON.parse @response.body
      end

      def next_page() links['next'] end
      def last_page() links['last'] end

      private

      def links
        return @links if defined? @links
        @links = {}
        if links = @response['Link']
          links.scan(/<([^>]+)>; rel="([^"]+)"/).each { |l, r| @links[r] = l }
        end
        @links
      end
    end

    CONTENT_TYPE = 'application/vnd.github.v3+json'
    USER_AGENT = 'ghi/%s (%s; +%s)' % [
      GHI::Commands::Version::VERSION,
      RUBY_DESCRIPTION,
      'https://github.com/stephencelis/ghi'
    ]
    METHODS = {
      :head   => Net::HTTP::Head,
      :get    => Net::HTTP::Get,
      :post   => Net::HTTP::Post,
      :put    => Net::HTTP::Put,
      :patch  => Net::HTTP::Patch,
      :delete => Net::HTTP::Delete
    }
    DEFAULT_HOST = 'api.github.com'
    HOST = GHI.config('github.host') || DEFAULT_HOST
    PORT = 443

    attr_reader :username, :password
    def initialize username = nil, password = nil
      @username, @password = username, password
    end

    def head path, options = {}
      request :head, path, options
    end

    def get path, params = {}, options = {}
      request :get, path, options.merge(:params => params)
    end

    def post path, body = nil, options = {}
      request :post, path, options.merge(:body => body)
    end

    def put path, body = nil, options = {}
      request :put, path, options.merge(:body => body)
    end

    def patch path, body = nil, options = {}
      request :patch, path, options.merge(:body => body)
    end

    def delete path, options = {}
      request :delete, path, options
    end

    private

    def request method, path, options
      path = "/api/v3#{path}" if HOST != DEFAULT_HOST

      path = URI.escape path
      if params = options[:params] and !params.empty?
        q = params.map { |k, v| "#{CGI.escape k.to_s}=#{CGI.escape v.to_s}" }
        path += "?#{q.join '&'}"
      end

      headers = options.fetch :headers, {}
      headers.update 'Accept' => CONTENT_TYPE, 'User-Agent' => USER_AGENT
      req = METHODS[method].new path, headers
      if GHI::Authorization.token
        req['Authorization'] = "token #{GHI::Authorization.token}"
      end
      if options.key? :body
        req['Content-Type'] = CONTENT_TYPE
        req.body = options[:body] ? JSON.dump(options[:body]) : ''
      end
      req.basic_auth username, password if username && password

      proxy   = GHI.config 'https.proxy', :upcase => false
      proxy ||= GHI.config 'http.proxy',  :upcase => false
      if proxy
        proxy = URI.parse proxy
        http = Net::HTTP::Proxy(proxy.host, proxy.port, proxy.user, proxy.password).new HOST, PORT
      else
        http = Net::HTTP.new HOST, PORT
      end

      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE # FIXME 1.8.7

      GHI.v? and puts "\r===> #{method.to_s.upcase} #{path} #{req.body}"
      res = http.start { http.request req }
      GHI.v? and puts "\r<=== #{res.code}: #{res.body}"

      case res
      when Net::HTTPSuccess
        return Response.new(res)
      when Net::HTTPUnauthorized
        if password.nil?
          raise Authorization::Required, 'Authorization required'
        end
      when Net::HTTPMovedPermanently, Net::HTTPTemporaryRedirect
        path = URI.parse(res['location']).path
        return request method, path, options
      end

      raise Error, res
    end
  end
end
require 'tmpdir'

module GHI
  class Editor
    attr_reader :filename
    def initialize filename
      @filename = filename
    end

    def gets prefill
      File.open path, 'a+' do |f|
        f << prefill if File.zero? path
        f.rewind
        system "#{editor} #{f.path}"
        return File.read(f.path).gsub(/(?:^\s*\<\!--.*--\>\s*$\n?)+\s*\z/, '').strip
      end
    end

    def unlink message = nil
      File.delete path
      abort message if message
    end

    private

    def editor
      editor   = GHI.config 'ghi.editor'
      editor ||= GHI.config 'core.editor'
      editor ||= ENV['VISUAL']
      editor ||= ENV['EDITOR']
      editor ||= 'vi'
    end

    def path
      File.join dir, filename
    end

    def dir
      @dir ||= git_dir || Dir.tmpdir
    end

    def git_dir
      return unless Commands::Command.detected_repo
      dir = `git rev-parse --git-dir 2>/dev/null`.chomp
      dir unless dir.empty?
    end
  end
end
require 'open-uri'
require 'uri'

module GHI
  class Web
    HOST = GHI.config('github.host') || 'github.com'
    BASE_URI = "https://#{HOST}/"

    attr_reader :base
    def initialize base
      @base = base
    end

    def open path = '', params = {}
      path = uri_for path, params
      $stdout.puts path
      return unless $stdout.tty?
      launcher = 'open'
      launcher = 'xdg-open' if /linux/ =~ RUBY_PLATFORM
      system "#{launcher} '#{path}'"
    end

    def curl path = '', params = {}
      proxy_uri   = GHI.config 'https.proxy', :upcase => false
      proxy_uri ||= GHI.config 'http.proxy',  :upcase => false
      proxy = nil
      if proxy_uri
        proxy = URI.parse proxy_uri
      end
      if proxy && proxy.user && proxy.password
        uri_for(path, params).open(:proxy_http_basic_authentication => [proxy_uri, proxy.user, proxy.password]).read
      else
        uri_for(path, params).open.read
      end
    end

    private

    def uri_for path, params
      unless params.empty?
        q = params.map { |k, v| "#{CGI.escape k.to_s}=#{CGI.escape v.to_s}" }
        path += "?#{q.join '&'}"
      end
      URI(BASE_URI) + "#{base}/" + path
    end
  end
end
module GHI
  module Commands
  end
end
module GHI
  module Commands
    class MissingArgument < RuntimeError
    end

    class Command
      include Formatting

      class << self
        attr_accessor :detected_repo

        def execute args
          command = new args
          if i = args.index('--')
            command.repo = args.slice!(i, args.length)[1] # Raise if too many?
          end
          command.execute
        end
      end

      attr_reader :args
      attr_writer :issue
      attr_accessor :action
      attr_accessor :verbose

      def initialize args
        @args = args.map! { |a| a.dup }
      end

      def assigns
        @assigns ||= {}
      end

      def api
        @api ||= Client.new
      end

      def repo
        return @repo if defined? @repo
        @repo = GHI.config('ghi.repo', :flags => '--local') || detect_repo
        if @repo && !@repo.include?('/')
          @repo = [Authorization.username, @repo].join '/'
        end
        @repo
      end
      alias extract_repo repo

      def repo= repo
        @repo = repo.dup
        unless @repo.include? '/'
          @repo.insert 0, "#{Authorization.username}/"
        end
        @repo
      end

      private

      def require_repo
        return true if repo
        warn <<-WARNING
Current directory is not a GitHub repository. Please retry this command from a
GitHub repository or by appending your command with the user/repo:

    #{GHI.current_command} -- [<user>/]<repo>

        WARNING
        abort options.to_s
      end

      def require_repo_name
        require_repo
        repo_array = repo.partition "/"
        if repo_array.length >= 2
          repo_name = repo_array[2]
        else
          repo_name = nil
        end
        return repo_name
      end

      def detect_repo
        remote   = remotes.find { |r| r[:remote] == 'upstream' }
        remote ||= remotes.find { |r| r[:remote] == 'origin' }
        remote ||= remotes.find { |r| r[:user]   == Authorization.username }
        Command.detected_repo = true and remote[:repo] if remote
      end

      def remotes
        return @remotes if defined? @remotes
        @remotes = `git config --get-regexp remote\..+\.url`.split "\n"
        github_host = GHI.config('github.host') || 'github.com'
        @remotes.reject! { |r| !r.include? github_host}
        @remotes.map! { |r|
          remote, user, repo = r.scan(
            %r{remote\.([^\.]+)\.url .*?([^:/]+)/([^/\s]+?)(?:\.git)?$}
          ).flatten
          { :remote => remote, :user => user, :repo => "#{user}/#{repo}" }
        }
        @remotes
      end

      def issue
        return @issue if defined? @issue
        if index = args.index { |arg| /^\d+$/ === arg }
          @issue = args.delete_at index
        else
          infer_issue_from_branch_prefix
        end
        @issue
      end
      alias extract_issue     issue
      alias milestone         issue
      alias extract_milestone issue

      def infer_issue_from_branch_prefix
        @issue = `git symbolic-ref --short HEAD 2>/dev/null`[/^\d+/];
        warn "(Inferring issue from branch prefix: ##@issue)" if @issue
      end

      def require_issue
        raise MissingArgument, 'Issue required.' unless issue
      end

      def require_milestone
        raise MissingArgument, 'Milestone required.' unless milestone
      end

      # Handles, e.g. `--[no-]milestone [<n>]`.
      def any_or_none_or input
        input ? input : { nil => '*', false => 'none' }[input]
      end

      def sort_by_creation(arr)
        arr.sort_by { |el| el['created_at'] }
      end
    end
  end
end
module GHI
  module Commands
    class Assign < Command
      def options
        OptionParser.new do |opts|
          opts.banner = <<EOF
usage: ghi assign [options] [<issueno>]
   or: ghi assign <issueno> <user>
   or: ghi unassign <issueno>
EOF
          opts.separator ''
          opts.on(
            '-u', '--assignee <user>', 'assign to specified user'
          ) do |assignee|
            assigns[:assignee] = assignee
          end
          opts.on '-d', '--no-assignee', 'unassign this issue' do
            assigns[:assignee] = nil
          end
          opts.on '-l', '--list', 'list assigned issues' do
            self.action = 'list'
          end
          opts.separator ''
        end
      end

      def execute
        self.action = 'edit'
        assigns[:args] = []

        require_repo
        extract_issue
        options.parse! args

        unless assigns.key? :assignee
          assigns[:assignee] = args.pop || Authorization.username
        end
        if assigns.key? :assignee
          assigns[:assignee].sub! /^@/, '' if assigns[:assignee]
          assigns[:args].concat(
            assigns[:assignee] ? %W(-u #{assigns[:assignee]}) : %w(--no-assign)
          )
        end
        assigns[:args] << issue if issue
        assigns[:args].concat %W(-- #{repo})

        case action
          when 'list' then List.execute assigns[:args]
          when 'edit' then Edit.execute assigns[:args]
        end
      end
    end
  end
end
module GHI
  module Commands
    class Close < Command
      attr_accessor :web

      def options
        OptionParser.new do |opts|
          opts.banner = <<EOF
usage: ghi close [options] <issueno>
EOF
          opts.separator ''
          opts.on '-l', '--list', 'list closed issues' do
            assigns[:command] = List
          end
          opts.on('-w', '--web') { self.web = true }
          opts.separator ''
          opts.separator 'Issue modification options'
          opts.on '-m', '--message [<text>]', 'close with message' do |text|
            assigns[:comment] = text
          end
          opts.separator ''
        end
      end

      def execute
        options.parse! args
        require_repo

        if list?
          args.unshift(*%W(-sc -- #{repo}))
          args.unshift '-w' if web
          List.execute args
        else
          require_issue
          if assigns.key? :comment
            Comment.execute [
              issue, '-m', assigns[:comment], '--', repo
            ].compact
          end
          Edit.execute %W(-sc #{issue} -- #{repo})
        end
      end

      private

      def list?
        assigns[:command] == List
      end
    end
  end
end
module GHI
  module Commands
    class Comment < Command
      attr_accessor :comment
      attr_accessor :verbose
      attr_accessor :web

      def options
        OptionParser.new do |opts|
          opts.banner = <<EOF
usage: ghi comment [options] <issueno>
EOF
          opts.separator ''
          opts.on '-l', '--list', 'list comments' do
            self.action = 'list'
          end
          opts.on('-w', '--web') { self.web = true }
          # opts.on '-v', '--verbose', 'list events, too'
          opts.separator ''
          opts.separator 'Comment modification options'
          opts.on '-m', '--message [<text>]', 'comment body' do |text|
            assigns[:body] = text
          end
          opts.on '--amend', 'amend previous comment' do
            self.action = 'update'
          end
          opts.on '-D', '--delete', 'delete previous comment' do
            self.action = 'destroy'
          end
          opts.on '--close', 'close associated issue' do
            self.action = 'close'
          end
          opts.on '-v', '--verbose' do
            self.verbose = true
          end
          opts.separator ''
        end
      end

      def execute
        require_issue
        require_repo
        self.action ||= 'create'
        options.parse! args

        case action
        when 'list'
          get_requests(:index, :events)
          res = index
          page do
            elements = sort_by_creation(res.body + paged_events(events, res))
            puts format_comments_and_events(elements)
            break unless res.next_page
            res = throb { api.get res.next_page }
          end
        when 'create'
          if web
            Web.new(repo).open "issues/#{issue}#issue_comment_form"
          else
            create
          end
        when 'update', 'destroy'
          res = index
          res = throb { api.get res.last_page } if res.last_page
          self.comment = res.body.reverse.find { |c|
            c['user']['login'] == Authorization.username
          }
          if comment
            send action
          else
            abort 'No recent comment found.'
          end
        when 'close'
          Close.execute [issue, '-m', assigns[:body], '--', repo].compact
        end
      end

      protected

      def index
        @index ||= throb { api.get uri, :per_page => 100 }
      end

      def create message = 'Commented.'
        e = require_body
        c = throb { api.post uri, assigns }.body
        puts format_comment(c)
        puts message
        e.unlink if e
      end

      def update
        create 'Comment updated.'
      end

      def destroy
        throb { api.delete uri }
        puts 'Comment deleted.'
      end

      def events
        @events ||= begin
          events = []
          res = api.get(event_uri, :per_page => 100)
          loop do
            events += res.body
            break unless res.next_page
            res = api.get res.next_page
          end
          events
        end
      end

      private

      def get_requests(*methods)
        threads = methods.map do |method|
          Thread.new { send(method) }
        end
        threads.each { |t| t.join }
      end

      def uri
        if comment
          comment['url']
        else
          "/repos/#{repo}/issues/#{issue}/comments"
        end
      end

      def event_uri
        "/repos/#{repo}/issues/#{issue}/events"
      end

      def require_body
        assigns[:body] = args.join ' ' unless args.empty?
        return if assigns[:body]
        if issue && verbose
          i = throb { api.get "/repos/#{repo}/issues/#{issue}" }.body
        else
          i = {'number'=>issue}
        end
        filename = "GHI_COMMENT_#{issue}"
        filename << "_#{comment['id']}" if comment
        filename << ".md"
        e = Editor.new filename
        message = e.gets format_comment_editor(i, comment)
        e.unlink 'No comment.' if message.nil? || message.empty?
        if comment && message.strip == comment['body'].strip
          e.unlink 'No change.'
        end
        assigns[:body] = message if message
        e
      end

      def paged_events(events, comments_res)
        if comments_res.next_page
          last_comment_creation = comments_res.body.last['created_at']
          events_for_this_page, @events = events.partition do |event|
            event['created_at'] < last_comment_creation
          end
          events_for_this_page
        else
          events
        end
      end
    end
  end
end
module GHI
  module Commands
    class Config < Command
      def options
        OptionParser.new do |opts|
          opts.banner = <<EOF
usage: ghi config [options]
EOF
          opts.separator ''
          opts.on '--local', 'set for local repo only' do
            assigns[:local] = true
          end
          opts.on '--auth [<username>]' do |username|
            self.action = 'auth'
            assigns[:username] = username || Authorization.username
          end
          opts.separator ''
        end
      end

      def execute
        # TODO: Investigate whether or not this variable is needed
        global = true

        options.parse! args.empty? ? %w(-h) : args

        if action == 'auth'
          assigns[:password] = Authorization.password || get_password
          Authorization.authorize!(
            assigns[:username], assigns[:password], assigns[:local]
          )
        end
      end

      private

      def get_password
        print "Enter #{assigns[:username]}'s GitHub password (never stored): "
        current_tty = `stty -g`
        system 'stty raw -echo -icanon isig' if $?.success?
        input = ''
        while char = $stdin.getbyte and not (char == 13 or char == 10)
          if char == 127 or char == 8
            input[-1, 1] = '' unless input.empty?
          else
            input << char.chr
          end
        end
        input
      rescue Interrupt
        print '^C'
      ensure
        system "stty #{current_tty}" unless current_tty.empty?
      end
    end
  end
end
module GHI
  module Commands
    class Edit < Command
      attr_accessor :editor

      def options
        OptionParser.new do |opts|
          opts.banner = <<EOF
usage: ghi edit <issueno> [options]
EOF
          opts.separator ''
          opts.on(
            '-m', '--message [<text>]', 'change issue description'
          ) do |text|
            next self.editor = true if text.nil?
            assigns[:title], assigns[:body] = text.split(/\n+/, 2)
          end
          opts.on(
            '-u', '--[no-]assign [<user>]', 'assign to specified user'
          ) do |assignee|
            assigns[:assignee] = assignee || nil
          end
          opts.on '--claim', 'assign to yourself' do
            assigns[:assignee] = Authorization.username
          end
          opts.on(
            '-s', '--state <in>', %w(open closed),
            {'o'=>'open', 'c'=>'closed'}, "'open' or 'closed'"
          ) do |state|
            assigns[:state] = state
          end
          opts.on(
            '-M', '--[no-]milestone [<n>]', Integer, 'associate with milestone'
          ) do |milestone|
            assigns[:milestone] = milestone
          end
          opts.on(
            '-L', '--label <labelname>...', Array, 'associate with label(s)'
          ) do |labels|
            (assigns[:labels] ||= []).concat labels
          end
          opts.separator ''
          opts.separator 'Pull request options'
          opts.on(
            '-H', '--head [[<user>:]<branch>]',
            'branch where your changes are implemented',
            '(defaults to current branch)'
          ) do |head|
            self.action = 'pull'
            assigns[:head] = head
          end
          opts.on(
            '-b', '--base [<branch>]',
            'branch you want your changes pulled into', '(defaults to master)'
          ) do |base|
            self.action = 'pull'
            assigns[:base] = base
          end
          opts.separator ''
        end
      end

      def execute
        self.action = 'edit'
        require_repo
        require_issue
        options.parse! args
        case action
        when 'edit'
          begin
            if editor || assigns.empty?
              i = throb { api.get "/repos/#{repo}/issues/#{issue}" }.body
              e = Editor.new "GHI_ISSUE_#{issue}.md"
              message = e.gets format_editor(i)
              e.unlink "There's no issue." if message.nil? || message.empty?
              assigns[:title], assigns[:body] = message.split(/\n+/, 2)
            end
            if i && assigns.keys.map { |k| k.to_s }.sort == %w[body title]
              titles_match = assigns[:title].strip == i['title'].strip
              if assigns[:body]
                bodies_match = assigns[:body].to_s.strip == i['body'].to_s.strip
              end
              if titles_match && bodies_match
                e.unlink if e
                abort 'No change.' if assigns.dup.delete_if { |k, v|
                  [:title, :body].include? k
                }
              end
            end
            unless assigns.empty?
              i = throb {
                api.patch "/repos/#{repo}/issues/#{issue}", assigns
              }.body
              puts format_issue(i)
              puts 'Updated.'
            end
            e.unlink if e
          rescue Client::Error => e
            raise unless error = e.errors.first
            abort "%s %s %s %s." % [
              error['resource'],
              error['field'],
              [*error['value']].join(', '),
              error['code']
            ]
          end
        when 'pull'
          begin
            assigns[:issue] = issue
            assigns[:base] ||= 'master'
            head = begin
              if ref = %x{
                git rev-parse --abbrev-ref HEAD@{upstream} 2>/dev/null
              }.chomp!
                ref.split('/', 2).last if $? == 0
              end
            end
            assigns[:head] ||= head
            if assigns[:head]
              assigns[:head].sub!(/:$/, ":#{head}")
            else
              abort <<EOF.chomp
fatal: HEAD can't be null. (Is your current branch being tracked upstream?)
EOF
            end
            throb { api.post "/repos/#{repo}/pulls", assigns }
            base = [repo.split('/').first, assigns[:base]].join ':'
            puts 'Issue #%d set up to track remote branch %s against %s.' % [
              issue, assigns[:head], base
            ]
          rescue Client::Error => e
            raise unless error = e.errors.last
            abort error['message'].sub(/^base /, '')
          end
        end
      end
    end
  end
end
module GHI
  module Commands
    class Disable < Command

      def options
        OptionParser.new do |opts|
          opts.banner = 'usage: ghi disable'
        end
      end

      def execute
        begin
          options.parse! args
          @repo ||= ARGV[0] if ARGV.one?
        rescue OptionParser::InvalidOption => e
          fallback.parse! e.args
          retry
        end
        repo_name = require_repo_name
        unless repo_name.nil?
          patch_data = {}
          patch_data[:name] = repo_name
          patch_data[:has_issues] = false
          res = throb { api.patch "/repos/#{repo}", patch_data }.body
          if !res['has_issues']
            puts "Issues are now disabled for this repo"
          else
            puts "Something went wrong disabling issues for this repo"
          end
        end
      end

    end
  end
end
module GHI
  module Commands
    class Enable < Command

      def options
        OptionParser.new do |opts|
          opts.banner = 'usage: ghi enable'
        end
      end

      def execute
        begin
          options.parse! args
          @repo ||= ARGV[0] if ARGV.one?
        rescue OptionParser::InvalidOption => e
          fallback.parse! e.args
          retry
        end
        repo_name = require_repo_name
        unless repo_name.nil?
          patch_data = {}
          patch_data[:name] = repo_name
          patch_data[:has_issues] = true
          res = throb { api.patch "/repos/#{repo}", patch_data }.body
          if res['has_issues']
            puts "Issues are now enabled for this repo"
          else
            puts "Something went wrong enabling issues for this repo"
          end
        end
      end

    end

  end
end
module GHI
  module Commands
    class Help < Command
      def self.execute args, message = nil
        new(args).execute message
      end

      attr_accessor :command

      def options
        OptionParser.new do |opts|
          opts.banner = 'usage: ghi help [--all] [--man|--web] <command>'
          opts.separator ''
          opts.on('-a', '--all', 'print all available commands') { all }
          opts.on('-m', '--man', 'show man page')                { man }
          opts.on('-w', '--web', 'show manual in web browser')   { web }
          opts.separator ''
        end
      end

      def execute message = nil
        self.command = args.shift if args.first !~ /^-/

        if command.nil? && args.empty?
          puts message if message
          puts <<EOF

The most commonly used ghi commands are:
   list        List your issues (or a repository's)
   show        Show an issue's details
   open        Open (or reopen) an issue
   close       Close an issue
   lock        Lock an issue's conversation, limiting it to collaborators
   unlock      Unlock an issue's conversation, opening it to all viewers
   edit        Modify an existing issue
   comment     Leave a comment on an issue
   label       Create, list, modify, or delete labels
   assign      Assign an issue to yourself (or someone else)
   milestone   Manage project milestones
   status      Determine whether or not issues are enabled for this repo
   enable      Enable issues for the current repo
   disable     Disable issues for the current repo

See 'ghi help <command>' for more information on a specific command.
EOF
          exit
        end

        options.parse! args.empty? ? %w(-m) : args
      end

      def all
        raise 'TODO'
      end

      def man
        GHI.execute [command, '-h']
        # TODO:
        # exec "man #{['ghi', command].compact.join '-'}"
      end

      def web
        raise 'TODO'
      end
    end
  end
end
module GHI
  module Commands
    class Label < Command
      attr_accessor :name

      #--
      # FIXME: This does too much. Opt for a secondary command, e.g.,
      #
      #   ghi label add <labelname>
      #   ghi label rm <labelname>
      #   ghi label <issueno> <labelname>...
      #++
      def options
        OptionParser.new do |opts|
          opts.banner = <<EOF
usage: ghi label <labelname> [-c <color>] [-r <newname>]
   or: ghi label -D <labelname>
   or: ghi label <issueno(s)> [-a] [-d] [-f] <label>
   or: ghi label -l [<issueno>]
EOF
          opts.separator ''
          opts.on '-l', '--list [<issueno>]', 'list label names' do |n|
            self.action = 'index'
            @issue ||= n
          end
          opts.on '-D', '--delete', 'delete label' do
            self.action = 'destroy'
          end
          opts.separator ''
          opts.separator 'Label modification options'
          opts.on(
            '-c', '--color <color>', 'color name or 6-character hex code'
          ) do |color|
            assigns[:color] = to_hex color
            self.action ||= 'create'
          end
          opts.on '-r', '--rename <labelname>', 'new label name' do |name|
            assigns[:name] = name
            self.action = 'update'
          end
          opts.separator ''
          opts.separator 'Issue modification options'
          opts.on '-a', '--add', 'add labels to issue' do
            self.action = issues_present? ? 'add' : 'create'
          end
          opts.on '-d', '--delete', 'remove labels from issue' do
            self.action = issues_present? ? 'remove' : 'destroy'
          end
          opts.on '-f', '--force', 'replace existing labels' do
            self.action = issues_present? ? 'replace' : 'update'
          end
          opts.separator ''
        end
      end

      def execute
        extract_issue
        require_repo
        options.parse! args.empty? ? %w(-l) : args

        if issues_present?
          self.action ||= 'add'
          self.name = args.shift.to_s.split ','
          self.name.concat args
          multi_action(action)
        else
          self.action ||= 'create'
          self.name ||= args.shift
          send action
        end
      end

      protected

      def index
        if issue
          uri = "/repos/#{repo}/issues/#{issue}/labels"
        else
          uri = "/repos/#{repo}/labels"
        end
        labels = throb { api.get uri }.body
        if labels.empty?
          puts 'None.'
        else
          puts labels.map { |label|
            name = label['name']
            colorize? ? bg(label['color']) { " #{name} " } : name
          }
        end
      end

      def create
        label = throb {
          api.post "/repos/#{repo}/labels", assigns.merge(:name => name)
        }.body
        return update if label.nil?
        puts "%s created." % bg(label['color']) { " #{label['name']} "}
      rescue Client::Error => e
        if e.errors.find { |error| error['code'] == 'already_exists' }
          return update
        end
        raise
      end

      def update
        label = throb {
          api.patch "/repos/#{repo}/labels/#{name}", assigns
        }.body
        puts "%s updated." % bg(label['color']) { " #{label['name']} "}
      end

      def destroy
        throb { api.delete "/repos/#{repo}/labels/#{name}" }
        puts "[#{name}] deleted."
      end

      def add
        labels = throb {
          api.post "/repos/#{repo}/issues/#{issue}/labels", name
        }.body
        puts "Issue #%d labeled %s." % [issue, format_labels(labels)]
      end

      def remove
        case name.length
        when 0
          throb { api.delete base_uri }
          puts "Labels removed."
        when 1
          labels = throb { api.delete "#{base_uri}/#{name.join}" }.body
          if labels.empty?
            puts "Issue #%d unlabeled." % issue
          else
            puts "Issue #%d labeled %s." % [issue, format_labels(labels)]
          end
        else
          labels = throb {
            api.get "/repos/#{repo}/issues/#{issue}/labels"
          }.body
          self.name = labels.map { |l| l['name'] } - name
          replace
        end
      end

      def replace
        labels = throb { api.put base_uri, name }.body
        if labels.empty?
          puts "Issue #%d unlabeled." % issue
        else
          puts "Issue #%d labeled %s." % [issue, format_labels(labels)]
        end
      end

      private

      def base_uri
        "/repos/#{repo}/#{issue ? "issues/#{issue}/labels" : 'labels'}"
      end

      # This method is usually inherited from Command and extracts a single issue
      # from args - we override it to handle multiple issues at once.
      def extract_issue
        @issues = []
        args.delete_if do |arg|
          arg.match(/^\d+$/) ? @issues << arg : break
        end
        infer_issue_from_branch_prefix unless @issues.any?
      end

      def issues_present?
        @issues.any? || @issue
      end

      def multi_action(action)
        if @issues.any?
          override_issue_reader
          threads = @issues.map do |issue|
            Thread.new do
              Thread.current[:issue] = issue
              send action
            end
          end
          threads.each(&:join)
        else
          send action
        end
      end

      def override_issue_reader
        def issue
          Thread.current[:issue]
        end
      end
    end
  end
end
require 'date'

module GHI
  module Commands
    class List < Command
      attr_accessor :web
      attr_accessor :reverse
      attr_accessor :quiet
      attr_accessor :exclude_pull_requests
      attr_accessor :pull_requests_only

      def options
        OptionParser.new do |opts|
          opts.banner = 'usage: ghi list [options]'
          opts.separator ''
          opts.on '-g', '--global', 'all of your issues on GitHub' do
            assigns[:filter] = 'all'
            @repo = nil
          end
          opts.on(
            '-s', '--state <in>', %w(open closed),
            {'o'=>'open', 'c'=>'closed'}, "'open' or 'closed'"
          ) do |state|
            assigns[:state] = state
          end
          opts.on(
            '-L', '--label <labelname>...', Array, 'by label(s)'
          ) do |labels|
            (assigns[:labels] ||= []).concat labels
          end
          opts.on(
            '-N', '--not-label <labelname>...', Array, 'exclude with label(s)'
          ) do |labels|
            (assigns[:exclude_labels] ||= []).concat labels
          end
          opts.on(
            '--no-labels', 'do not print labels'
          ) do
            assigns[:dont_print_labels] = true
          end
          opts.on(
            '-S', '--sort <by>', %w(created updated comments),
            {'c'=>'created','u'=>'updated','m'=>'comments'},
            "'created', 'updated', or 'comments'"
          ) do |sort|
            assigns[:sort] = sort
          end
          opts.on '--reverse', 'reverse (ascending) sort order' do
            self.reverse = !reverse
          end
          opts.on('-p', '--pulls','list only pull requests') { self.pull_requests_only = true }
          opts.on('-P', '--no-pulls','exclude pull requests') { self.exclude_pull_requests = true }
          opts.on(
            '--since <date>', 'issues more recent than',
            "e.g., '2011-04-30'"
          ) do |date|
            begin
              assigns[:since] = DateTime.parse date # TODO: Better parsing.
            rescue ArgumentError => e
              raise OptionParser::InvalidArgument, e.message
            end
          end
          opts.on('-v', '--verbose') { self.verbose = true }
          opts.on('-w', '--web') { self.web = true }
          opts.separator ''
          opts.separator 'Global options'
          opts.on(
            '-f', '--filter <by>',
            filters = %w[all assigned created mentioned subscribed],
            Hash[filters.map { |f| [f[0, 1], f] }],
            filters.map { |f| "'#{f}'" }.join(', ')
          ) do |filter|
            assigns[:filter] = filter
          end
          opts.on '--mine', 'assigned to you' do
            assigns[:filter] = 'assigned'
            assigns[:assignee] = Authorization.username
          end
          opts.separator ''
          opts.separator 'Project options'
          opts.on(
            '-M', '--[no-]milestone [<n>]', Integer,
            'with (specified) milestone'
          ) do |milestone|
            assigns[:milestone] = any_or_none_or milestone
          end
          opts.on(
            '-u', '--[no-]assignee [<user>]', 'assigned to specified user'
          ) do |assignee|
            assignee = assignee.sub /^@/, '' if assignee
            assigns[:assignee] = any_or_none_or assignee
          end
          opts.on '--mine', 'assigned to you' do
            assigns[:filter] = 'assigned'
            assigns[:assignee] = Authorization.username
          end
          opts.on(
            '--creator [<user>]', 'created by you or specified user'
          ) do |creator|
            creator = creator.sub /^@/, '' if creator
            assigns[:creator] = creator || Authorization.username
          end
          opts.on(
            '-U', '--mentioned [<user>]', 'mentioning you or specified user'
          ) do |mentioned|
            assigns[:mentioned] = mentioned || Authorization.username
          end
          opts.on(
            '-O', '--org <organization>', 'in repos within an organization you belong to'
          ) do |org|
	    assigns[:org] = org
            @repo = nil
          end
            opts.on(
              '--by-milestone', 'filter by milestone'
            ) do
              assigns[:by_m] = true
            end
          opts.separator ''
        end
      end

      def execute
        if index = args.index { |arg| /^@/ === arg }
          assigns[:assignee] = args.delete_at(index)[1..-1]
        end

        begin
          options.parse! args
          @repo ||= ARGV[0] if ARGV.one?
        rescue OptionParser::InvalidOption => e
          fallback.parse! e.args
          retry
        end
        assigns[:labels] = assigns[:labels].join ',' if assigns[:labels]
        if assigns[:exclude_labels]
          assigns[:exclude_labels] = assigns[:exclude_labels].join ','
        end
        if reverse
          assigns[:sort] ||= 'created'
          assigns[:direction] = 'asc'
        end
        if web
          Web.new(repo || 'dashboard').open 'issues', assigns
        else
          assigns[:per_page] = 100
          unless quiet
            print header = format_issues_header
            print "\n" unless paginate?
          end
          res = throb(
            0, format_state(assigns[:state], quiet ? CURSOR[:up][1] : '#')
          ) { api.get uri, assigns }
          print "\r#{CURSOR[:up][1]}" if header && paginate?
          page header do
            issues = res.body

            if exclude_pull_requests || pull_requests_only
              prs, issues = issues.partition { |i| i.key?('pull_request') }
              issues = prs if pull_requests_only
            end
            if assigns[:exclude_labels]
              issues = issues.reject  do |i|
                i["labels"].any? do |label|
                  assigns[:exclude_labels].include? label["name"]
                end
              end
            end
            if verbose
              puts issues.map { |i| format_issue i }
            else
              if assigns[:by_m]
                puts format_issues_by_milestone(issues, repo.nil?)
              else
                puts format_issues(issues, repo.nil?)
              end
            end
            break unless res.next_page
            res = throb { api.get res.next_page }
          end
        end
      rescue Client::Error => e
        if e.response.code == '422'
          e.errors.any? { |err|
            err['code'] == 'missing' && err['field'] == 'milestone'
          } and abort 'No such milestone.'
        end

        raise
      end

      private

      def uri
        url = ''
        if repo
          url = "/repos/#{repo}"
        end
	if assigns[:org]
          url = "/orgs/#{assigns[:org]}"
        end
        return url << '/issues'
      end

      def fallback
        OptionParser.new do |opts|
          opts.on('-c', '--closed') { assigns[:state] = 'closed' }
          opts.on('-q', '--quiet')  { self.quiet = true }
        end
      end
    end
  end
end
module GHI
  module Commands
    class Lock < Command
      def options
        OptionParser.new do |opts|
          opts.banner = <<EOF
usage: ghi lock [options] <issueno>
EOF
          opts.separator ''
          opts.separator 'Issue modification options'
          opts.on '-m', '--message [<text>]', 'lock with message' do |text|
            assigns[:comment] = text
          end
          opts.separator ''
        end
      end

      def execute
        options.parse! args
        require_repo
        require_issue

        if assigns.key? :comment
          Comment.execute [
            issue, '-m', assigns[:comment], '--', repo
          ].compact
        end

        throb { api.put "/repos/#{repo}/issues/#{issue}/lock" }

        puts 'Locked.'
      rescue Client::Error => e
        raise unless error = e.errors.first
        abort "%s %s %s %s." % [
          error['resource'],
          error['field'],
          [*error['value']].join(', '),
          error['code']
        ]
      end
    end
  end
end
require 'date'

module GHI
  module Commands
    class Milestone < Command
      attr_accessor :edit
      attr_accessor :reverse
      attr_accessor :web

      #--
      # FIXME: Opt for better interface, e.g.,
      #
      #   ghi milestone [-v | --verbose] [--[no-]closed]
      #   ghi milestone add <name> <description>
      #   ghi milestone rm <milestoneno>
      #++
      def options
        OptionParser.new do |opts|
          opts.banner = <<EOF
usage: ghi milestone [<modification options>] [<milestoneno>]
   or: ghi milestone -D <milestoneno>
   or: ghi milestone -l [-c] [-v]
EOF
          opts.separator ''
          opts.on '-l', '--list', 'list milestones' do
            self.action = 'index'
          end
          opts.on '-c', '--[no-]closed', 'show closed milestones' do |closed|
            assigns[:state] = closed ? 'closed' : 'open'
          end
          opts.on(
            '-S', '--sort <on>', %w(due_date completeness),
            {'d'=>'due_date', 'due'=>'due_date', 'c'=>'completeness'},
            "'due_date' or 'completeness'"
          ) do |sort|
            assigns[:sort] = sort
          end
          opts.on '--reverse', 'reverse (ascending) sort order' do
            self.reverse = !reverse
          end
          opts.on '-v', '--verbose', 'list milestones verbosely' do
            self.verbose = true
          end
          opts.on('-w', '--web') { self.web = true }
          opts.separator ''
          opts.separator 'Milestone modification options'
          opts.on(
            '-m', '--message [<text>]', 'change milestone description'
          ) do |text|
            self.action = 'create'
            self.edit = true
            next unless text
            assigns[:title], assigns[:description] = text.split(/\n+/, 2)
          end
          # FIXME: We already describe --[no-]closed; describe this, too?
          opts.on(
            '-s', '--state <in>', %w(open closed),
            {'o'=>'open', 'c'=>'closed'}, "'open' or 'closed'"
          ) do |state|
            self.action = 'create'
            assigns[:state] = state
          end
          opts.on(
            '--due <on>', 'when milestone should be complete',
            "e.g., '2012-04-30'"
          ) do |date|
            self.action = 'create'
            begin
              # TODO: Better parsing.
              assigns[:due_on] = DateTime.parse(date).strftime
            rescue ArgumentError => e
              raise OptionParser::InvalidArgument, e.message
            end
          end
          opts.on '-D', '--delete', 'delete milestone' do
            self.action = 'destroy'
          end
          opts.separator ''
        end
      end

      def execute
        self.action = 'index'
        require_repo
        extract_milestone

        begin
          options.parse! args
        rescue OptionParser::AmbiguousOption => e
          fallback.parse! e.args
        end

        milestone and case action
          when 'create' then self.action = 'update'
          when 'index'  then self.action = 'show'
        end

        if reverse
          assigns[:sort] ||= 'created'
          assigns[:direction] = 'asc'
        end

        case action
        when 'index'
          if web
            Web.new(repo).open 'milestones', assigns
          else
            assigns[:per_page] = 100
            state = assigns[:state] || 'open'
            print format_state state, "# #{repo} #{state} milestones"
            print "\n" unless paginate?
            res = throb(0, format_state(state, '#')) { api.get uri, assigns }
            page do
              milestones = res.body
              if verbose
                puts milestones.map { |m| format_milestone m }
              else
                puts format_milestones(milestones)
              end
              break unless res.next_page
              res = throb { api.get res.next_page }
            end
          end
        when 'show'
          if web
            List.execute %W(-w -M #{milestone} -- #{repo})
          else
            m = throb { api.get uri }.body
            page do
              puts format_milestone(m)
              puts 'Issues:'
              args.unshift(*%W(-q -M #{milestone} -- #{repo}))
              args.unshift '-v' if verbose
              List.execute args
              break
            end
          end
        when 'create'
          if web
            Web.new(repo).open 'issues/milestones/new'
          else
            if assigns[:title].nil?
              e = Editor.new 'GHI_MILESTONE.md'
              message = e.gets format_milestone_editor
              e.unlink 'Empty milestone.' if message.nil? || message.empty?
              assigns[:title], assigns[:description] = message.split(/\n+/, 2)
            end
            m = throb { api.post uri, assigns }.body
            puts 'Milestone #%d created.' % m['number']
            e.unlink if e
          end
        when 'update'
          if web
            Web.new(repo).open "issues/milestones/#{milestone}/edit"
          else
            if edit || assigns.empty?
              m = throb { api.get "/repos/#{repo}/milestones/#{milestone}" }.body
              e = Editor.new "GHI_MILESTONE_#{milestone}.md"
              message = e.gets format_milestone_editor(m)
              e.unlink 'Empty milestone.' if message.nil? || message.empty?
              assigns[:title], assigns[:description] = message.split(/\n+/, 2)
            end
            if assigns[:title] && m
              t_match = assigns[:title].strip == m['title'].strip
              if assigns[:description]
                b_match = assigns[:description].strip == m['description'].strip
              end
              if t_match && b_match
                e.unlink if e
                abort 'No change.' if assigns.dup.delete_if { |k, v|
                  [:title, :description].include? k
                }
              end
            end
            m = throb { api.patch uri, assigns }.body
            puts format_milestone(m)
            puts 'Updated.'
            e.unlink if e
          end
        when 'destroy'
          require_milestone
          throb { api.delete uri }
          puts 'Milestone deleted.'
        end
      end

      private

      def uri
        if milestone
          "/repos/#{repo}/milestones/#{milestone}"
        else
          "/repos/#{repo}/milestones"
        end
      end

      def fallback
        OptionParser.new do |opts|
          opts.on '-d' do
            self.action = 'destroy'
          end
        end
      end
    end
  end
end
module GHI
  module Commands
    class Open < Command
      attr_accessor :editor
      attr_accessor :web

      def options
        OptionParser.new do |opts|
          opts.banner = <<EOF
usage: ghi open [options]
   or: ghi reopen [options] <issueno>
EOF
          opts.separator ''
          opts.on '-l', '--list', 'list open tickets' do
            self.action = 'index'
          end
          opts.on('-w', '--web') { self.web = true }
          opts.separator ''
          opts.separator 'Issue modification options'
          opts.on(
              '-m', '--message [<text>]', 'describe issue',
              "use line breaks to separate title from description"
          ) do |text|
            if text
              assigns[:title], assigns[:body] = text.split(/\n+/, 2)
            else
              self.editor = true
            end
          end
          opts.on(
            '-u', '--[no-]assign [<user>]', 'assign to specified user'
          ) do |assignee|
            assigns[:assignee] = assignee
          end
          opts.on '--claim', 'assign to yourself' do
            assigns[:assignee] = Authorization.username
          end
          opts.on(
            '-M', '--milestone <n>', 'associate with milestone'
          ) do |milestone|
            assigns[:milestone] = milestone
          end
          opts.on(
            '-L', '--label <labelname>...', Array, 'associate with label(s)'
          ) do |labels|
            (assigns[:labels] ||= []).concat labels
          end
          opts.separator ''
        end
      end

      def execute
        require_repo
        self.action = 'create'

        options.parse! args

        if GHI.config('ghi.infer-issue') != 'false' && extract_issue
          Edit.execute args.push('-so', issue, '--', repo)
          exit
        end

        case action
        when 'index'
          if assigns.key? :assignee
            args.unshift assigns[:assignee] if assigns[:assignee]
            args.unshift '-u'
          end
          args.unshift '-w' if web
          List.execute args.push('--', repo)
        when 'create'
          if web
            Web.new(repo).open 'issues/new'
          else
            unless args.empty?
              assigns[:title], assigns[:body] = args.join(' '), assigns[:title]
            end
            assigns[:title] = args.join ' ' unless args.empty?
            if assigns[:title].nil? || editor
              e = Editor.new 'GHI_ISSUE.md'
              message = e.gets format_editor(assigns)
              e.unlink "There's no issue?" if message.nil? || message.empty?
              assigns[:title], assigns[:body] = message.split(/\n+/, 2)
            end
            i = throb { api.post "/repos/#{repo}/issues", assigns }.body
            e.unlink if e
            puts format_issue(i)
            puts "Opened on #{repo}."
          end
        end
      rescue Client::Error => e
        raise unless error = e.errors.first
        abort "%s %s %s %s." % [
          error['resource'],
          error['field'],
          [*error['value']].join(', '),
          error['code']
        ]
      end
    end
  end
end
module GHI
  module Commands
    class Show < Command
      attr_accessor :patch, :web

      def options
        OptionParser.new do |opts|
          opts.banner = 'usage: ghi show <issueno>'
          opts.separator ''
          opts.on('-p', '--patch') { self.patch = true }
          opts.on('-w', '--web') { self.web = true }
        end
      end

      def execute
        require_issue
        require_repo
        options.parse! args
        patch_path = "pull/#{issue}.patch" if patch # URI also in API...
        if web
          Web.new(repo).open patch_path || "issues/#{issue}"
        else
          if patch_path
            i = throb { Web.new(repo).curl patch_path }
            unless i.start_with? 'From'
              warn 'Patch not found'
              abort
            end
            page do
              no_color { puts i }
              break
            end
          else
            i = throb { api.get "/repos/#{repo}/issues/#{issue}" }.body
            determine_merge_status(i) if pull_request?(i)
            page do
              puts format_issue(i)
              n = i['comments']
              if n > 0
                puts "#{n} comment#{'s' unless n == 1}:\n\n"
                Comment.execute %W(-l #{issue} -- #{repo})
              end
              break
            end
          end
        end
      end

      private

      def pull_request?(issue)
        issue.key?('pull_request')
      end

      def determine_merge_status(pr)
        pr['merged'] = true if pr['state'] == 'closed' && merged?
      end

      def merged?
        # API returns with a Not Found error when the PR is not merged
        api.get "/repos/#{repo}/pulls/#{issue}/merge" rescue false
      end
    end
  end
end
module GHI
  module Commands
    class Status < Command

      def options
        OptionParser.new do |opts|
          opts.banner = 'usage: ghi status'
        end
      end

      def execute
        begin
          options.parse! args
          @repo ||= ARGV[0] if ARGV.one?
        rescue OptionParser::InvalidOption => e
          fallback.parse! e.args
          retry
        end

        require_repo
        res = throb { api.get "/repos/#{repo}" }.body

        if res['has_issues']
          puts "Issues are enabled for this repo"
        else
          puts "Issues are not enabled for this repo"
        end

      end
    end
  end
end
module GHI
  module Commands
    class Unlock < Command
      def options
        OptionParser.new do |opts|
          opts.banner = <<EOF
usage: ghi unlock [options] <issueno>
EOF
          opts.separator ''
          opts.separator 'Issue modification options'
          opts.on '-m', '--message [<text>]', 'unlock with message' do |text|
            assigns[:comment] = text
          end
          opts.separator ''
        end
      end

      def execute
        options.parse! args
        require_repo
        require_issue

        throb { api.delete "/repos/#{repo}/issues/#{issue}/lock" }

        if assigns.key? :comment
          Comment.execute [
            issue, '-m', assigns[:comment], '--', repo
          ].compact
        end

        puts 'Unlocked.'
      rescue Client::Error => e
        raise unless error = e.errors.first
        abort "%s %s %s %s." % [
          error['resource'],
          error['field'],
          [*error['value']].join(', '),
          error['code']
        ]
      end
    end
  end
end
#!/usr/bin/env ruby
GHI.execute ARGV