#!/usr/bin/env python3
from sys import stdin

while True:
    # TOdo; Take encoding/codec as a parameter
    try:
        l = stdin.readline()
    except UnicodeDecodeError as e:
        break
    if not l:
        break

    if l.count(' ') > 5:
        print(l)
