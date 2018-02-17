#!/bin/bash

################
# Config
################

export GPU_FORCE_64BIT_PTR=1
export GPU_MAX_HEAP_SIZE=100
export GPU_USE_SYNC_OBJECTS=1
export GPU_MAX_ALLOC_PERCENT=100
export GPU_SINGLE_ALLOC_PERCENT=100


# Plain connection
#ethminer --farm-recheck 200 -SP 1 -G -S eth.2miners.com:2020 -O 0x7e5533116dbd23b113d3288aacbf4d2122f88ad3.bula

#
# Detached session
#
screen -dmS ethminer /usr/local/bin/ethminer --farm-recheck 2000 -SP 1 -G -S eth.2miners.com:2020 -O 0x7e5533116dbd23b113d3288aacbf4d2122f88ad3.bula

#
# Show mining
#
screen -x ethminer
