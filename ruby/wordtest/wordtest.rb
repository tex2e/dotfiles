#!/usr/bin/env ruby
#:readme:
#
# ## wordtest(1) -- test your vocabulary
#
# [code](wordtest.rb)
#
# ### Usage
#
#     wordtest
#
# press `↓` or space key to go to next day.
# `↑` key to go to previous day.
# `→` key to go to next week.
# `←` key to go to previous week.
# `Ctrl+c` or `Ctrl+d` to exit.
#

require 'pp'
require 'yaml'
require 'io/console'

class WordList
  def initialize
    @word_list = YAML.load_file("#{Dir.home}/.dotfiles/ruby/wordtest/1100words.yml")
  end

  def show_at(week:, day:)
    show(week, day)
  end

  def show(week, day)
    page = @word_list["week#{week}day#{day}"]
    puts "===week#{week}day#{day}==="
    puts
    if day != 5
      puts "[New Words]"
      puts page["new_words"].map { |word| "http://ejje.weblio.jp/content/#{word}" }
      puts
      puts "[Reading]"
      puts page["reading"]
      puts
      puts "[Sample Sentences]"
      puts page["sample_sentences"]
      puts
      puts "[Definitions]"
      printf_as_table(page["definitions"])
      puts
      answer = @word_list["answers"]["week#{week}day#{day}"]
      puts "[Answer]"
      printf_as_table(answer)
      puts
      puts "[Todays Idiom]"
      puts page["todays_idiom"]
    else # day == 5
      puts "[Definitions]"
      printf_as_table(page["definitions"])
      puts
      puts "[Idioms]"
      printf_as_table(page["idioms"])
      puts
      answer = @word_list["answers"]["week#{week}day#{day}"]
      puts "[Answer]"
      printf_as_table(answer, 20)
    end
  end

  private
  def printf_as_table(array, halfpoint=nil)
    halfpoint = array.length / 2 if halfpoint.nil?

    longest_key = array[0...halfpoint].max_by(&:length)
    array[0...halfpoint].zip( array[halfpoint...array.length] ) do |pair|
      printf("%-#{longest_key.length}s  %s\n", pair.first, pair.last)
    end
  end
end


word_list = WordList.new
max_week = 46
max_day = 5
week_and_days = [*1..max_week].product([*1..max_day])
index = 0

week = ARGV[0] || 1
day  = ARGV[1] || 1

puts "\e[H\e[2J" # clear screen
word_list.show(week, day)
while true
  break if (key = STDIN.getch) == "\C-c" || key == "\C-d"
  key = STDIN.getch if key == "\e" && STDIN.getch == "["

  case key
  when "j"; index += 1 # ↓
  when "k"; index -= 1 # ↑
  when "l"; index += max_day # →
  when "h"; index -= max_day # ←
  when " "; index += 1
  when "q"; break
  else; next
  end

  puts "\e[H\e[2J" # clear screen
  index %= week_and_days.length
  week, day = week_and_days[index]
  word_list.show(week, day)
end
