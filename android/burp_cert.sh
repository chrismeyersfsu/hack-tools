#!/bin/bash

openssl x509 -inform DER -in $1 -out cacert.pem
CERT_HASH=`openssl x509 -inform PEM -subject_hash_old -in cacert.pem |head -1`
mv cacert.pem ${CERT_HASH}.0
adb root
adb remount
adb shell mkdir -p /system/etc/security/cacerts/
adb push ${CERT_HASH}.0 /system/etc/security/cacerts/
adb reboot
