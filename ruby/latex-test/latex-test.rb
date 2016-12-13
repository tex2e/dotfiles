#!/usr/bin/env ruby

require 'test/unit'

class LaTeX
  attr_reader :text

  def initialize(filepath)
    @text = File.read(filepath)
    @text.gsub!(/\%.*$/, "")
  end

  def document
    @document ||= @text.match(/\\begin{document}(.*?)\\end{document}/m)[1]
  end

  def labels(&block)
    @labels ||= @text.scan(/label[={]([^,\}\]]*)/).flatten
    @labels.tap { |array| array.each(&block) if block_given? }
  end

  def refs(&block)
    @refs ||= @text.scan(/\\ref{(.*?)}/).flatten
    @refs.tap { |array| array.each(&block) if block_given? }
  end

  def figures(&block)
    @figures ||= @text.scan(/\\begin{figure}(.*?)\\end{figure}/m).flatten
    @figures.tap { |array| array.each(&block) if block_given? }
  end

  def tables(&block)
    @tables ||= @text.scan(/\\begin{table}(.*?)\\end{table}/mx).flatten
    @tables.tap { |array| array.each(&block) if block_given? }
  end

  def listings(&block)
    @listings ||= @text.scan(%r{
      \\begin{lstlisting}.*?\[(.*?)\]
      |
      \\lstinputlisting.*?\[(.*?)\]
    }mx)
    .flatten.compact
    @listings.tap { |array| array.each(&block) if block_given? }
  end

  def sections(&block)
    @sections ||= @text.scan(/\\section{.*}/)
    @sections.tap { |array| array.each(&block) if block_given? }
  end
end

# ## Check Sheet
#
# Marked as "x" means covered by this unit-test.
#
# ### Prof. Ito's Check Sheet
#
# - [ ] ページ番号が記入されているか?
# - [ ] 表紙にまでページ番号が記入されていないか?
# - [x] 章立てして書いているか?
# - [x] 図と表はセンタリングされているか?
# - [x] 図や表の一つ一つに通し番号と具体的なキャプションがついているか?
# - [x] 「上の図」「次の表」のような物理的な位置関係ではなく、「図1」「図2」のように番号で参照しているか?
# - [x] 図のキャプションは図の下に、表のキャプションは表の上に、それぞれ配置されているか?
# - [ ] レポート中の図表は全て本文で説明されているか?
# - [ ] 本文には 10〜11 ポイントの明朝体が使われているか?
# - [ ] ページの上下左右の余白が 2.5cm〜3.0cm程度の範囲になっているか?
# - [ ] 日本語の作文ルールに従っているか?
#
# ### Custom Rules
#
# - [x] 句読点には「。」と「、」の代わりに「．」と「，」を使う。
# - [x] ですます調は使わない。
#

class TestReportFormat < Test::Unit::TestCase
  @@filepath = ARGV[0]
  raise ArgumentError, 'wrong number of arguments (expected 1)' if @@filepath.nil?
  raise "no such a file or directory: #{@@filepath}" unless File.exist?(@@filepath)

  def setup
    @pdf = LaTeX.new(@@filepath)
  end

  # --- labels and refs ---

  def test_labels_refs
    assert_equal @pdf.labels.sort.uniq, @pdf.refs.sort.uniq
  end

  # --- figures ---

  def test_figure_contains_label_definition
    @pdf.figures do |fig|
      assert_match /\\label{.*?}/, fig, '\\label is not defined at figure'
    end
  end

  def test_figure_contains_caption_definition
    @pdf.figures do |fig|
      assert_match /\\caption{.*?}/, fig, '\\caption is not defined at figure'
    end
  end

  def test_figure_caption_has_placed_correct_position
    @pdf.figures do |fig|
      assert_match /\\includegraphics.*\\caption{.*?}.*?/m, fig, 'In figure tag, \\caption must be placed after \\includegraphics'
    end
  end

  def test_figure_has_centering
    @pdf.figures do |fig|
      assert_match /\\begin{center}|\\centering/, fig, '\\figure must be centering'
    end
  end

  # --- tables ---

  def test_table_contains_label_definition
    @pdf.tables do |tab|
      assert_match /\\label{.*?}/, tab, '\\label is not defined at table'
    end
  end

  def test_table_contains_caption_definition
    @pdf.tables do |tab|
      assert_match /\\caption{.*?}/, tab, '\\caption is not defined at table'
    end
  end

  def test_table_caption_has_placed_correct_position
    @pdf.tables do |tab|
      assert_match /\\caption{.*?}.*?\\begin{tabular}/m, tab, 'In table tag, \\caption must be placed behind before \\begin{tabular}'
    end
  end

  def test_table_has_centering
    @pdf.tables do |tab|
      assert_match /center/, tab, '\\table must be centering'
    end
  end

  # --- listings ---

  def test_listing_contains_label_definition
    @pdf.listings do |list|
      assert_match /label=.*?/, list, '\\label is not defined at listing'
    end
  end

  def test_listing_contains_caption_definition
    @pdf.listings do |list|
      assert_match /caption=.*?/, list, '\\caption is not defined at listing'
    end
  end

  def test_wrote_with_section
    assert !@pdf.sections.empty?
  end

  # --- document ---

  def test_should_use_absolute_ref
    assert_no_match /[上下右左次]の[表図]/, @pdf.document, 'should use absolute ref like "図1" or "表1"'
  end

  def test_should_not_use_ordinary_punctuation
    assert_no_match /[。、]/, @pdf.document, 'should use "．" and "，" as punctuation'
  end

  def test_should_not_use_desu_masu_dialect
    assert_no_match /です|ます/, @pdf.document, 'should not use "です" or "ます" as end of sentences'
  end

  def test_should_not_have_hardcorded_serial_numbers
    assert_no_match /[表図]\d+/, @pdf.document, 'should not have hardcorded serial number(s)'
  end
end
