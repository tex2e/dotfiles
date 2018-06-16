#!/bin/bash -u

set -e

function success {
  printf " \033[32m✔ \033[m%s\n" "$*"
}
function fail {
  printf " \033[31m✘ \033[m%s\n" "$*"
}

which python3 &>/dev/null \
&& success "found Python3" || fail "not found Python3"
which convert &>/dev/null \
&& success "found ImageMagic" || fail "not found ImageMagic"
python3 -c 'from pptx import Presentation' &>/dev/null \
&& success "found pip python-pptx" || fail "not found pip python-pptx"

mkdir -p pages
rm pages/presen-*.jpg || true
convert -density 300 presen.pdf pages/presen-%02d.jpg
python3 bin/pdf2pptx.py pages presen-note.txt
