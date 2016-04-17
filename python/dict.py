#!/usr/bin/env python
#
# dict - a command line dictionary for UNIX
#

import socket, sys, re

if len(sys.argv) == 1:
    sys.exit("Usage: " + sys.argv[0] + "  [dictionary server]")


pat = re.compile("250 ok")
pat2 = re.compile("\.|2\d\d");
pat3 = re.compile("1\d\d")
errpat = re.compile("552 no match");
errpat2 = re.compile("551");
#create an INET, STREAMing socket
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
#now connect to the dictionary server on port 2628
# By default it connects to www.dict.org unless overridden by the
# command line
if len(sys.argv) == 3:
    s.connect((sys.argv[2], 2628))
else:
    s.connect(("www.dict.org", 2628))

s.send("define * " + '"' + sys.argv[1].strip() + '"' + "\r\n\r\n")
buf = ''

while 1:
    tmpbuf = s.recv(1024)
    if not tmpbuf:
        break
    buf += tmpbuf
    if errpat.search(tmpbuf):
        sys.stdout.write("No definitions found for " + '"' + sys.argv[1].strip() + '"')
        s.send("match * lev " + '"' + sys.argv[1].strip() + '"' + "\r\n\r\n")

        res = s.recv(80)
        if errpat.search(res) or errpat2.search(res):
            print('')
            s.send("quit\r\n")
            s.close()
            sys.exit()
        else:
            sys.stdout.write(", perhaps you mean:")
            suggestions = s.recv(2048)
            source = ''

            for line in suggestions.splitlines():
                if source != '':
                    prev = source[0]
                else:
                    prev = ''
                if pat.match(line) or pat2.match(line):
                    break
                source = line.split(' ')
                if prev == source[0]:
                    sys.stdout.write('  ' + source[1].strip('"'))
                else:
                    sys.stdout.write('\n' + source[0] + ':' + '  ' + source[1].strip('"'))
            print('')

            s.send("quit\r\n");
            s.close()
            sys.exit()
    if pat.search(tmpbuf):
        break


for line in buf.splitlines():
    if pat2.match(line):
        continue
    if pat3.match(line):
        if line.find('" ') != -1:
            a = line.split('" ')
            print('')
            b = str(a[1]).split(' ');
            c = ' '.join(b[1:])
            d = c.split('"')
            print("From " + d[1] + ' ' + '[' + b[0] + ']' + ":\n")
        else:
            a = line.split(' ')
            a[3] = "found"

            print(' '.join(a[1:]))
        continue
    sys.stdout.write('  ' + line + "\n")

s.send("quit\r\n");
s.close()
