#!/bin/sh
echo "unicode: '\%31%31%31' ==> "
echo "\%31%31%31" | ./decode.py
echo "urlencode: '%31%31%31' ==> "
echo "%31%31%31" | ./decode.py
echo "urlencode with embedded unicode: '%5C%2531%2531%2531' ==> "
echo "%5C%2531%2531%2531" | ./decode.py | ./decode.py
