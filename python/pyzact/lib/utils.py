#!/usr/bin/env python3

def get_ifs(args):
    return args.ifs or args.fs

def get_ofs(args):
    return args.ofs or args.fs

def write_eos(args):
    if args.eos:
        print(args.eos)

def exit_by_sigpipe():
    import sys
    import signal
    signal.signal(signal.SIGPIPE, lambda e: sys.exit())

def add_common_options(argument_parser):
    argument_parser.add_argument(
        '--fs', metavar='separator', default=' ',
        help='Field separator.')
    argument_parser.add_argument(
        '--ifs', metavar='separator', default=None,
        help='Input field separator. If fs is already set, this option is primarily used.')
    argument_parser.add_argument(
        '--ofs', metavar='separator', default=None,
        help='Output field separator. If fs is already set, this option is primarily used.')
    argument_parser.add_argument(
        '--eos', metavar='separator', default=None,
        help='End of set. Set means, all results generated from single line, in this manual.')
