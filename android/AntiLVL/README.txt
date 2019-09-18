AntiLVL - Android License Verification Library Subversion
by lohan+

[ What is it? ]
AntiLVL's purpose is to subvert standard license protection methods such as the Android License Verification Library (LVL), Amazon Appstore DRM and Verizon DRM. It also disables many anti-cracking and anti-tampering protection methods. Because every implementation of the LVL is potentially (and often is) quite different, it's not possible to automate patching in every case. It will not always work. However, it has been designed to get around obfuscation and to apply many variations.

Under the hood, AntiLVL is a configurable Smali code patcher with rules defined in user-modifiable XML files stored inside the jar called fingerprints. Brief summary of how it works:
* Decompiles the Apk
* Perform  regular expression matching
* Carrie out defined modifications
* Recompile, update classes.dex
* Resign and zipalign


[ Who is it for? ]
* Android developers that wish to test their protection methods against common types of attacks. The fact that the tool exist may encourage developers to either give up on protection and focus on making better Apps or, on the other extreme, to develop a robust protection mechanism that will detour all but the most adamant crackers.

* Those wishing to automate the task of patching Apk files for whatever reason.

* The curious that wish to know more about Android cracking. AntiLVL is an easy way to understand several typical techniques.


[ Usage ]
Typical usage:
  java -jar antilvl.jar sample-lvl-app.apk

This will create sample-lvl-all-antilvl.apk.


Usage: java -jar AntiLVL.jar [options] <Apktool/Baksmali dump | Apk file> [Output Apk]
Options:
  -f, --force           Allow overwriting of any existent file
  -s, --skip-assembly   Decompile and modify but do not rebuild
  -d, --detect-only     Detect protection information only
  -n, --lvl-only        Skip all protections except Android Market LVL
  --sign-only           Sign Apk file then exit
  --info-only           Get App info then exit
  --assemble-only       Assemble dump, update Output Apk, sign, zipalign, exit
  --skip-cleanup        Do not delete dump directory after running
  --sign-key            PK8 key to sign with (requires --sign-cert)
  --sign-cert           PEM certificate to sign with (reqires --sign-key)
  --sign-pass           Password to use with signature
  --fplist              List installed fingerprints
  --fpexclude           Comma-separated list of fingerprints to exclude
  --fpinclude           Comma-separated list of fingerprints to include
  -v#, --verbose#       Verbose level (1-3)
  -h, --help            Show this friendly message

Specific DRM Options:
  --amazon-only         Skip Non Amazon App Store DRM subversion
  --verizon-only        Skip Non Verizon App Store DRM subversion

Advanced Hook Parameters:
  --chksigs #           Check signatures behavior
    0 - *default* only match signatures if installed
    1 - always return signature match
  --getpi #             Get PackageInfo behavior
    0 - *default* spoof key/pro/full Apps if not installed
    1 - do not spoof apps not installed

If the App fails to work properly after processing (ex: force closes), it could be the app uses a hooked method in an unpredicted way. Play with the --lvl-only, and --fpexclude options to prevent AntiLVL from hooking those methods. You can use --fplist to see all of the fingerprints. Anything that starts with "Hook" is a likely candidate for exclusion.

I assume you know how to install / uninstall Apps. My preferred method is with adb. If you need to uninstall first, AntiLVL will give you the package name when it first starts if it knows.

To uninstall:	adb uninstall sample.package.name
To install:		adb install sample-lvl-app-antilvl.apk

This package includes two binaries: aapt and zipalign. Aapt is for getting package information and zipalign is for optimizing performance of the Apk. They must be in the same directory as AntiLVL or in your path. For more information on how zipalign works, check out:
http://developer.android.com/guide/developing/tools/zipalign.html

If you are using Linux, you may need to set execute permissions on them. For example:
chmod 755 aapt
chmod 755 zipalign


[ AntiLVL Hacking ]
Included is an Apk called TestTarget. It's used as a test for AntiLVL before release. It contains examples of all the protection methods AntiLVL knows how to defeat. It's included with the Eclipse project source. If you want to develop your own fingerprints, you can use TestTarget to test it afterward. It mainly tests just the anti-cracking and anti-tamper methods, not the LVL or market-specific DRM.

To add your own custom fingerprints, open the AntiLVL jar with a zip archive viewer, such as 7zip and browse to /fingerprints. Check out fingerprints.xml for documentation and examples, and also look at the others to get a good idea of how stuff works. You can add your rules to any of the XML files, but custom.xml is empty and just for you! The XML specification is _way_ overkill for what is needed for just some simple patching, so it should be flexible enough to do all kinds of weird stuff.

If you find AntiLVL is making false positives or incorrectly modifying a file, you can score yourself some bonus points by fixing it yourself in the fingerprint definitions, and super bonus points for sending in the fix.


[ Caveats ]
AntiLVL will not work well against any type of bizzare custom protection. It understands some trivial license checks but any sort of advanced non-LVL protection will not work. If this happens, your best bet is to use AntiLVL as a means of detecting anti-cracking code. Just run it normally using --skip-cleanup and modify the resulting Smali dump by hand until satisfied. Reassemble with --assemble-only with the previously created *-antilvl.apk as target.

If you have any questions, comments, suggestions or if AntiLVL does not work and you are reasonably sure the App is using Market LVL, Amazon or Verizon DRM, contact me. :D


[ Contact ]
lohan.plus (at) g m a i l (dot) com
http://androidcracking.blogspot.com



[ Changes ]
October 18th, 2011 - 1.4.0
  - Complete rewrite (because no developer is happy until it's been rewritten _at least_ 3 times)
  - Added --sign-pass, --sign-key and --sign-cert options to sign with your own signatures
  - Added support for patching Verizon DRM
  - Added support for patching / stripping Amazon DRM (thanks zart!)
    . Stripping is the default, patching can be enabled in place of stripping with --fpexclude "Amazon DRM Strip"
  - Changed fpinclude and fpexclude to be case-insensitive
  - Added file permission checks for aapt and zipalign
  - Major changes to SmaliHook
    . Split up into multiple sections so they can be included as needed
    . Added recursive method invocation hook
      Instead of hard coding hooks, use script vars of the form %!Hook:hook_name.methodName%"
  - Changed how afterOP and beforeOP are handled so they work as you would think
      It only really applied to inserts and replaces, but now they work for finds/matches
  - All fingerprint operation types can be defined with :#, ex: type="insert:3" where 3
      is the limit on the number of times it will attempt that operation.
  - Properly implemented multiple fingerprint region support
  - TestTarget updated with cool icon, more info and new anti-cracking / anti-antilvl checks
  - Added --getpi option to determine how hook handles getting PackageInfo
  - Changed --fplist so it will show which fingerprints are disabled
  - Changed --fpinclude and --fpexclude to work with Java regex
    . Ex: To exclude all Hooks, --fpexclude Hook.*
  
April 18th, 2011 - 1.1.5
  - Tweaked (hopefully improved) LVL detection (Thanks Notion and SuRViVe!)
  - Added hooks for app is debuggable and debugger connected checks

April 8th, 2011 - 1.1.4
  - Added Amazon DRM subversion
  - Fingerprint improvements
    . Fixed some LVL detection
    . Fixed problem with start of method not always being correctly found
    . Removed the possibility for several unnecessary checks, increasing speed
  - Several SmaliHook improvements, including more informative log messages
  - Updated documentation in fingerprints.xml but it's wise to also look at examples.
  - Added notifications for suspicious behavior
    . Getting the installed apk path - reason: usually a file size check
       Apps usually want to look at themselves to check for tampering (md5 hash, file size, etc.)
    . Getting device id, wireless mac, bluetooth mac, sim serial number - reason: unique identifiers
       Some services use these as unique identifiers for your device and they must be spoofed to avoid bans
  - Added spoof-id option for device / android_id spoofing
  - Included TestTarget.apk as a demo / educational resource
  
February 13th, 2011 - 1.1.3
  - Added --fplist, --fpexclude options (for warezhka), so you can exclude certain
      changes that you think might be breaking your Apk
  - Fixed several possible problems with hooks (thanks SuRViVe)
  - Major refactoring to create reusable libraries I'll release when they're not so ugly
  
February 6th, 2011 - 1.1.2
  - Fixed --skip-nonlvl, -n option
  - Fixed improper instances of packages being unnecessarily detected as installed
      Though this may hinder some key / pro / unlock checks
  - Improved accuracy of a few checks
  - Added two anti-cracking hooks
  - Added limited support for API key replacement
      Full support requires resource decoding/building which is planned for 1.2
  - Improved signature spoofing
  - Now creates output Apk path if it does not exist
  
January 30th, 2011 - 1.1
  - Introduced many anti-cracking bypassing methods. It's better than me!
  - Improved --sign-only behavior, though it still errors every other time
  - Fixed issue with modification's sometimes being done improperly
  - Several under the hood improvements for future features
  
January 21st, 2011 - 1.0
  - Complete rewrite of previous versions
  - Acts more like an engine, with modification information stored in fingerprints.xml
  - Many, many more Apk files can be decompiled and recompiled
  - Handles several new types of protection methods
  - Signature checking, a common anti-tampering technique, is subverted
  - File size / last modification checks are more accurately detected
  - Pro / Full unlock app protection is correctly handled sometimes
  - Much more compact / optimized java byte code, --clever option :D