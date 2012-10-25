#!/usr/bin/python

"""
Convert urlencoded data (i.e. %20) to the ascii representation.
* Handles urlencoding (%20,%30)
* Handles unicode (\u0000)
* Handles unicode (%u0000)
* Handles urlencoding (%20,%30) that then results in unicode (\u0000)
Keywords:
	* javascript
	* POST data
	* url data
	* unicode
"""

from urllib import unquote

def unquote_u(source):
	result = unquote(source)
	result = result.replace('%u', '\\u')
	result = result.decode('unicode_escape')
	return result

while True:
	try:
		line = raw_input()
	except EOFError:
		break;
	result = unquote_u(line)
	print result
