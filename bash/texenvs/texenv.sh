#! /bin/bash

set -u
SCRIPT=`basename $0 .sh`

# to use this to create tex enviroment, type:
# 
#     texenv
#     make init
# 
# further infomation is in ${TEXENV_DIR}/Makefile.mk
# 

TEXENV_DIR="$HOME/.dotfiles/bash/texenvs"

option=${1:-null}

#
# create Makefile
#
if [ $# = 0 ] || [ $option = make ]; then
	printf 'writing Makefile ... '
	# begin writing
	cat << EOF > "$PWD"/Makefile
# This Makefile is generated automatically by $SCRIPT
TEXENV_DIR=${TEXENV_DIR}
include \$(TEXENV_DIR)/Makefile.mk

.PHONY: init pdf clean distclean

init: OUTPUT = report.tex
init: original_init
	@printf 'OUTPUT=%s\n' \$(OUTPUT)
	cp -i $TEXENV_DIR/template.tex \$(PWD)/\$(OUTPUT) || true

pdf clean distclean:

selfupdate:
	texenv
EOF
	# end writing
	echo 'done'
	exit 0
fi

#
# create Rakefile if specified
#
if [ $option = rake ]; then
	printf 'writing Rakefile ... '
	# begin writing
	cat << EOF > "$PWD"/Rakefile
# This Rakefile is generated automatically by $SCRIPT
TEXENV_DIR = '${TEXENV_DIR}'
import "#{TEXENV_DIR}/Rakefile.rb"

desc 'write template tex file'
task :init => :original_init do
	output_file = ENV['OUTPUT'] || 'report.tex'
	puts "OUTPUT=#{output_file}"
	sh "cp -i $TEXENV_DIR/template.tex \$PWD/#{output_file} || true"
end

desc 'update self'
task :selfupdate do
	sh '$SCRIPT rake'
end
EOF
	# end writing
	echo 'done'
	exit 0
fi

