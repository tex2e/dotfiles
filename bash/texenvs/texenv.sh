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

if [ $# = 0 ] || [ $option = make ]; then
	printf 'writing Makefile ... '
	# begin writing
	cat << EOF > "$PWD"/Makefile
# This Makefile is generated automatically by $SCRIPT
TEXENV_DIR=${TEXENV_DIR}
include \$(TEXENV_DIR)/Makefile.make

.PHONY: init pdf clean distclean

init pdf clean distclean:

selfupdate:
	texenv
EOF
	# end writing
	echo 'done'
	exit 0
fi

if [ $option = rake ]; then
	printf 'writing Rakefile ... '
	# begin writing
	cat << EOF > "$PWD"/Rakefile
# This Rakefile is generated automatically by $SCRIPT
TEXENV_DIR = '${TEXENV_DIR}'
import "#{TEXENV_DIR}/Rakefile.rake"

desc 'update self'
task :selfupdate do
	sh '$SCRIPT rake'
end
EOF
	# end writing
	echo 'done'
	exit 0
fi

