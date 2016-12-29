#!/bin/bash -e

NEWLINE='
'

# Create temporary file.
tmpfile=$(mktemp)

function rm_tmpfile {
  [[ -f "$tmpfile" ]] && rm -f "$tmpfile"
}
trap rm_tmpfile EXIT
trap 'trap - EXIT; rm_tmpfile; exit -1' INT PIPE TERM

# Save the data from stdin to tmpfile.
cat > "$tmpfile"

# Count up data column
max_column=$(cat "$tmpfile" | head -n 1 | wc -w)

# --- Build up gnuplot directives ---
gnuplot_directives=

if ! [[ $# -eq 0 ]]; then
  gnuplot_directives+="set terminal png$NEWLINE"
  gnuplot_directives+="set output '$1'$NEWLINE"
fi

if [[ "$(cat "$tmpfile" | head -n 1 | cut -f 1)" =~ ^[0-9] ]]; then
  # normal plot
  gnuplot_directives+="unset key$NEWLINE"
  gnuplot_directives+="plot "
  for (( i = 2; i <= $max_column; i++ )); do
    gnuplot_directives+="'$tmpfile' using 1:$i with lines, "
  done
else
  # plot with title
  titles=$(cat "$tmpfile" | head -n 1)
  gnuplot_directives+="plot "
  for (( i = 2; i <= $max_column; i++ )); do
    title=$(echo "$titles" | cut -f $i)
    gnuplot_directives+="'$tmpfile' using 1:$i with lines title '$title', "
  done
fi

echo "$gnuplot_directives"

gnuplot -p <<EOF
$gnuplot_directives
EOF
