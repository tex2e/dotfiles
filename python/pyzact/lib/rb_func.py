#!/usr/bin/env python3

# output
def each_slice(n, seq):
    import itertools
    args = [iter(seq)] * n
    return itertools.zip_longest(*args, fillvalue='')
