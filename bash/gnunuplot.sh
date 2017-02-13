#!/bin/bash -e
#:readme:
#
# ## gnunuplot(1) -- Plot graph with data from stdin
#
# [code](gnunuplot.sh)
#
# ### SYNOPSIS
#
#     gnunuplot [--xlabel <label>] [--ylabel <label>] [<output_file>]
#
# ### Description
#
# Plot graph with data from stdin
#
# ### Usage
#
#     cat foo.dat | gnunuplot foo.png
#

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

for OPT in "$@"
do
  case "$OPT" in
    '--xlabel' )
      if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
        echo "$PROGNAME: option requires an argument -- $1" 1>&2
        exit 1
      fi
      XLABEL="$2"
      shift 2
      ;;
    '--ylabel' )
      if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
        echo "$PROGNAME: option requires an argument -- $1" 1>&2
        exit 1
      fi
      YLABEL="$2"
      shift 2
      ;;
    '--' | '-' )
      shift 1
      params+=( "$@" )
      break
      ;;
    -*)
      echo "$PROGNAME: illegal option -- '$(echo $1 | sed 's/^-*//')'" 1>&2
      exit 1
      ;;
    *)
      if [[ ! -z "$1" ]] && [[ ! "$1" =~ ^-+ ]]; then
        params+=( "$1" )
        shift 1
      fi
      ;;
  esac
done

# whether output png
if [[ -n "$params" ]]; then
  gnuplot_directives+="set terminal png$NEWLINE"
  gnuplot_directives+="set output '$params'$NEWLINE"
fi

# whether set labels
if [[ -n "$XLABEL" ]]; then
  gnuplot_directives+="set xlabel '$XLABEL'$NEWLINE"
fi
if [[ -n "$YLABEL" ]]; then
  gnuplot_directives+="set ylabel '$YLABEL'$NEWLINE"
fi

# whether data has header
if [[ "$(cat "$tmpfile" | head -n 1 | cut -f 1)" =~ ^[0-9] ]]; then
  # normal plot
  gnuplot_directives+="unset key$NEWLINE"
  gnuplot_directives+="plot "
  for (( i = 2; i <= $max_column; i++ )); do
    gnuplot_directives+="'$tmpfile' using 1:$i with lines, "
  done
else
  # plot with legend
  legends=$(cat "$tmpfile" | head -n 1)
  gnuplot_directives+="plot "
  for (( i = 2; i <= $max_column; i++ )); do
    legend=$(echo "$legends" | cut -f $i)
    gnuplot_directives+="'$tmpfile' using 1:$i with lines title '$legend', "
  done
fi

echo "$gnuplot_directives"

gnuplot -p <<EOF
$gnuplot_directives
EOF
