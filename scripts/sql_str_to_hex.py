#!/usr/bin/env python3

'''
https://support.portswigger.net/customer/portal/articles/2590739-sql-injection-bypassing-common-filters-

SELECT username FROM users WHERE isadmin = 2 union select name from sqlol.ssn where name='herp derper'--

is equivalent to:

SELECT username FROM users WHERE isadmin = 2 union select name from sqlol.ssn where name=0x4865727020446572706572--
'''

from sys import stdin
import binascii

while True:
    line = stdin.readline()

    if not line:
        break

    h = binascii.hexlify(line.encode('ascii'))
    print('0x{}'.format(h.decode('utf-8')))
