require 'pp'
require 'yaml'

class WordList
  def initialize
    @word_list = YAML.load_file('1100words.yml')
  end

  def show(week:, day:)
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
      puts page["definitions"]
      puts
    else # day == 5
      puts "[Definitions]"
      puts page["definitions"]
      puts
      puts "[Idioms]"
      puts page["idioms"]
      puts
    end

    answer = @word_list["answers"]["week#{week}day#{day}"]
    puts "[Answer]"
    puts answer
    puts
  end
end

word_list = WordList.new
(1..46).each do |week|
  (1..5).each do |day|
    word_list.show(week, day)
    begin
      Kernel.gets
    rescue Interrupt
      exit
    end
  end
end
