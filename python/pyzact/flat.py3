#!/usr/bin/env python3
#
# ## flat(1) --
#
# [code](flat.py3)
#
# ### Description
#
# Print whole the inputs as multiple rows with given number of cols.
# In default, it just removes the new lines.
#
# ### Usage
#
#     seq 10 | flat
#     1 2 3 4 5 6 7 8 9 10
#

import sys
import argparse
import fileinput
import signal
import re

# catch pipe close signal
def sigpipe_handler(e):
    sys.exit()

signal.signal(signal.SIGPIPE, sigpipe_handler)

# Parse args
parser = argparse.ArgumentParser(
    description='Print whole the inputs as multiple rows with given number of cols.')
parser.add_argument(
    'cols', metavar='N', type=int, nargs='?', default=float('inf'),
    help='number of cols')
parser.add_argument(
    '-d', dest='delimiter', action='append', metavar='delim', default=['\n'],
    help='delimiter')

args = parser.parse_args()
del sys.argv[:]

# output
array = []
delim = ''.join(args.delimiter)
split_regex = re.compile('[%s]' % delim)

for line in fileinput.input():
    for item in re.split(split_regex, line.strip()):
        array.append(item)
        if len(array) >= args.cols:
            print(' '.join(array))
            del array[:args.cols]

if len(array) > 0:
    print(' '.join(array))
