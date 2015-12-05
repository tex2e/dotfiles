
TEXENV_DIR = "~/.dotfiles/bash/texenvs"

tex_cmd = 'platex -recorder'
source_files = Rake::FileList['*.tex']


task :default => :pdf

desc 'Create directory images/ and latex template file.'
task :init do
	mkdir 'images' rescue true

	output_file = ENV['OUTPUT'] || 'report.tex'
	puts "OUTPUT=#{output_file}"
	sh "cp -i #{TEXENV_DIR}/template.tex $PWD/#{output_file} || true"
end

rule '.dvi' => '.tex' do |t|
	command = "yes q | #{tex_cmd} #{t.source}"
	result = `#{command}`
	puts command, result

	# remake dvi file, if necessary.
	while result.match(/Rerun to get cross-references right\./)
		result = `#{command}`
		puts result
	end
end

rule '.pdf' => '.dvi' do |t|
	sh "dvipdfmx -d5 #{t.source}"
end

desc 'Create pdf from dvi file'
task :pdf => source_files.ext('.pdf')

desc 'Create pdf and open it'
task :open => source_files.ext('.pdf') do |t|
	sh "open #{t.prerequisites.join(' ')}"
end

require 'rake/clean'

# rake clean
generated = %W(.log .dvi .aux .fls)
generated.each do |extention|
	CLEAN.include(source_files.ext(extention))
end

# rake clobber
CLOBBER.include(source_files.ext('.pdf'))
