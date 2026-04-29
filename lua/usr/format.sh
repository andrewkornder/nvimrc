#!/usr/bin/env bash

clion format -s $(dirname "$0")/.clion-format.xml "$1" &> /dev/null && \
    cat $1
