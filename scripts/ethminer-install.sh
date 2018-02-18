#!/bin/bash

#
# The `ethminer` installation doesn't happen during the
# unattended install. Execute this one time after 
# intial system setup
#

cd ~/ethminer/build
cmake ..
cmake --build .
make install
