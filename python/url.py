#!/usr/bin/env python3
#:readme:
#
# ## url(1) -- encode, decode URL string
#
# [code](url.py)
#
# ### SYNOPSIS
#
#     url {decode,encode} <string>
#
# ### Usage
#
#     url decode "https://ja.wikipedia.org/wiki/C%E8%A8%80%E8%AA%9E"
#

import sys
import re
import codecs
import urllib.parse

import argparse

parser = argparse.ArgumentParser(description="encode, decode URL string")
subparsers = parser.add_subparsers(dest='operator')
parser_decode = subparsers.add_parser('decode', help='Decode URL.')
parser_encode = subparsers.add_parser('encode', help='Encode URL.')
parser.add_argument('string', help="URL string.")
args = parser.parse_args()

def main(args):
    if args.operator == 'decode':
        return urllib.parse.unquote(args.string)
    else:
        url = args.string
        m = re.match(r'^(https?://)(.*)$', url)
        if m:
            # Don't encode "https://" to "https%3A//"
            string = codecs.escape_decode(m[2].encode())[0]
            return m[1] + urllib.parse.quote(string)
        else:
            string = codecs.escape_decode(args.string.encode())[0]
            return urllib.parse.quote(string)

if __name__ == '__main__':
    print(main(args))
