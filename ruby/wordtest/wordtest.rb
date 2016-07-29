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
      longest_key = page["definitions"][0...5].max_by(&:length)
      page["definitions"][0...5].zip(page["definitions"][5...10]) do |pair|
        printf("%-#{longest_key.length}s  %s\n", pair.first, pair.last)
      end
      puts
      answer = @word_list["answers"]["week#{week}day#{day}"]
      puts "[Answer]"
      puts answer
    else # day == 5
      puts "[Definitions]"
      longest_key = page["definitions"][0...20].max_by(&:length)
      page["definitions"][0...20].zip(page["definitions"][20...40]) do |pair|
        printf("%-#{longest_key.length}s  %s\n", pair.first, pair.last)
      end
      puts
      puts "[Idioms]"
      longest_key = page["idioms"][0...4].max_by(&:length)
      page["idioms"][0...4].zip(page["idioms"][4...8]) do |pair|
        printf("%-#{longest_key.length}s  %s\n", pair.first, pair.last)
      end
      puts
      answer = @word_list["answers"]["week#{week}day#{day}"]
      puts "[Answer]"
      longest_key = answer[0...20].max_by(&:length)
      answer[0...20].zip(answer[20...24]) do |pair|
        printf("%-#{longest_key.length}s  %s\n", pair.first, pair.last)
      end
    end
  end
end


word_list = WordList.new
max_week = 46
max_day = 5
week_and_days = [*1..max_week].product([*1..max_day])
index = 0

puts "\e[H\e[2J" # clear screen
word_list.show_at(week: 1, day: 1)
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
