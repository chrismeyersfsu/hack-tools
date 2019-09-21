#!/bin/sh

THIS_DIR=$(dirname "$0")

# about: Run some binary inside a docker container
# usage: ./drun <binary_name>
function drun() {
    docker run --rm -v `pwd`:/tmp/bin --name sandbox ubuntu:18.04 /tmp/bin/$1
}

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
