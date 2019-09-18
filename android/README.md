## Tools
AntiLVL - Patch apk to remove google play check that ensures you purchased the app or the check that you are in the beta program for an app. Good for taking an app from a device you have access to and putting on one that does not (i.e. emulator).
Note: Old project.
Note: works with java 8 i.e. `sudo update-alternatives --config java`
LuckyPatcher - https://www.luckypatchers.com - Remove Android LVL check.

## Guides

### Android + Burp Suite Proxy

Note: only works on Android < 10.0 & non-google-play productiony emulators
* Generate certificate from burp suite i.e. http://localhost:8080 click top right to download.
```
openssl x509 -inform DER -in cacert.der -out cacert.pem
openssl x509 -inform PEM -subject_hash_old -in cacert.pem |head -1
```

```
adb root
adb remount
adb push cacert.pem /system/etc/security/cacerts/<hash>.0
adb shell chmod 644 /syste/etc/security/cacerts/<hash>.0
adb root
```

Start Android emulator pointing to proxy.
`./emulator @proxy_write -http-proxy 127.0.0.2:8080 -writable-system`
