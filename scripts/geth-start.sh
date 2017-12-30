#!/bin/bash

#
# Start node
#
# Type `screen -x geth` to view
# `Ctrl-A-D` to put process in background
#
screen -dmS geth /usr/bin/geth --rpc --rpcaddr "0.0.0.0"
