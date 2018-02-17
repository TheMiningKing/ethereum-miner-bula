#!/bin/bash

#
# Start node
#
# Type `screen -x geth` to view
# `Ctrl-A-D` to put process in background
#
#screen -dmS geth /usr/bin/geth --rpc --rpcaddr "0.0.0.0"

./geth-start.sh


#
# Start ethminer
#
# Type `screen -x etheminer` to view
# `Ctrl-A-D` to put process in background
#

#./dwarfpool-start.sh
./2miners-start.sh
