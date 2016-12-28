#!/bin/bash -e

# create temporary file.
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

# If arguments aren't given, plot to window.
if [ $# -eq 0 ]
then

gnuplot -p <<EOF
unset key
plot for [col=2:$max_column] '$tmpfile' using 1:col with line
EOF

# If arguments aren't given, output png.
else

gnuplot <<EOF
unset key
set terminal png
set output '$1'
plot for [col=2:$max_column] '$tmpfile' using 1:col with line
EOF

fi
