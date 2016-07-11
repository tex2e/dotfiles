require 'pp'
require 'yaml'
require 'io/console'

class WordList
  def initialize
    @word_list = YAML.load_file('1100words.yml')
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
    end

    answer = @word_list["answers"]["week#{week}day#{day}"]
    puts "[Answer]"
    puts answer
    puts
  end
end


word_list = WordList.new
max_week = 46
max_day = 5
week_and_days = [*1..max_week].product([*1..max_day])
index = 0

word_list.show_at(week: 1, day: 1)
while true
  break if (key = STDIN.getch) == "\C-c" || key == "\C-d"
  key = STDIN.getch if key == "\e" && STDIN.getch == "["

  case key
  when "A"; index -= 1 # ↑
  when "B"; index += 1 # ↓
  when "C"; index += 1 # →
  when "D"; index -= 1 # ←
  else; next
  end

  index %= week_and_days.length
  week, day = week_and_days[index]
  word_list.show(week, day)
end
