#!/usr/bin/env python3

import sys
import subprocess
import os


def create_ln_path(profile, root, fname):
    (base, ext) = os.path.splitext(fname)
    ln_src = os.path.join(profile, fname)
    ln_dest = os.path.join('screenshot_smart', '{}-{}{}'.format(base, profile, ext))
    os.system('ln -s {} {}'.format(ln_src, ln_dest))


image = sys.argv[1]

lines = subprocess.getoutput('volatility -f {} imageinfo'.format(image)).split('\n')

for l in lines:
    if 'Suggested Profile' in l:
        profiles = l.split(':')[1].split(', ')

if profiles:
    print("Profiles: {}".format(' '.join(profiles)))
else:
    print('\n'.join(lines))

if len(sys.argv) >= 3:
    virt_cmd = sys.argv[2]

    if virt_cmd == 'screenshot_smart':
        print("Running screenshot_smart ...")
        os.system('mkdir -p screenshot_smart')
        for index, prof in enumerate(profiles):
            subdir = 'screenshot_smart/{}'.format(prof)
            os.system('mkdir -p {}'.format(subdir))

            # Generate screenshots
            lines = subprocess.getoutput('volatility -f {} --profile={} --dump-dir {} screenshot'.format(image, prof, subdir)).split('\n')
            print(lines)

            # link screenshots
            subdir = 'screenshot_smart/{}'.format(prof)
            for r, d, f in os.walk(subdir):
                for name in f:
                    create_ln_path(prof, r, name)

