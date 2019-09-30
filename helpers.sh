#!/bin/sh

THIS_DIR=$(dirname "$0")

# about: Run some binary inside a docker container
# usage: ./drun <binary_name>
function drun() {
    docker run --rm -v `pwd`:/tmp/bin --name sandbox ubuntu:18.04 /tmp/bin/$1
}

# Run common strings commands
function strings_smart() {
    local OUTFILE=strings/all.log
    local SMART_FILE=strings/smart.log

    mkdir -p strings/

    strings -e b $1 | tee -a $OUTFILE
    strings -e l $1 | tee -a $OUTFILE
    strings -e s $1 | tee -a $OUTFILE
    strings -e S $1 | tee -a $OUTFILE
    strings -e B $1 | tee -a $OUTFILE
    strings -e L $1 | tee -a $OUTFILE

    cat $OUTFILE | $THIS_DIR/scripts/string_filter.py | tee -a $SMART_FILE
}

alias v_profile=$THIS_DIR/scripts/volatility_iterate_profiles.py

# Run common volatility commands
function v_smart() {
    set -x
    v pslist > pslist.log
    v pstree > pstree.log
    v envars > envars.log
    v handles > handles.log
    v filescan > filescan.log
    v clipboard > clipboard.log
    v iehistory > iehistory.log
    v consoles > consoles.log

    mkdir -p screenshot/
    v screenshot --dump-dir screenshot

    mkdir -p memdump/
    v memdump --dump-dir memdump

    mkdir -p procdump/
    v procdump --dump-dir procdump

    mkdir -p dumpfiles/
    v procdump --dump-dir dumpfiles
}

alias drun='docker run --rm -it -v `pwd`:/tmp/files ubuntu'

# Extract memory from virtualbox dump i.e. `vboxmanage debugvm "Win7" dumpvmcore --filename test.elf`
function vbox_extract_mem() {
    objdump -h $1 | egrep -w "(Idx|load1)"
    size=`objdump -h $1 | egrep -w "(Idx|load1)" | perl -ne '/load1\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)/;print($1 . " ") if $1;'`
    off=`objdump -h $1 | egrep -w "(Idx|load1)" | perl -ne '/load1\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)/;print(int($4)) if $4'`
    head -c $(($size+$off)) test.elf|tail -c +$(($off+1)) > test.raw

}
