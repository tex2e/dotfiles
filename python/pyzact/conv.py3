#!/usr/bin/env python3
#
# ## conv(1) -- convolution
#
# [code](conv.py3)
#
# ### Description
#
# Print whole the inputs as multiple rows with given number of cols.
# Location of each field is shifted over to the left by comparison with one upper line.
# The reason why the name is conv is, the behavior looks like the convolution.
#
# ### Usage
#
#     $ seq 10 | conv 2
#     1 2
#     2 3
#     3 4
#     4 5
#     5 6
#     6 7
#     7 8
#     8 9
#     9 10
#
#     $ yes | awk '$0=NR' | conv 3 | head
#     1 2 3
#     2 3 4
#     3 4 5
#     4 5 6
#     5 6 7
#     .
#     .
#     .
#

import sys
import fileinput
import signal

# catch pipe close signal
def sigpipe_handler(e):
    sys.exit()

signal.signal(signal.SIGPIPE, sigpipe_handler)

# number of cols (default is 2)
num = 2
if len(sys.argv) >= 2:
    num = int(sys.argv[1])
    sys.argv.pop(1)

# output
array = []
for line in fileinput.input():
    array.append(line.strip())
    if len(array) >= num:
        print(' '.join(array))
        array.pop(0)
