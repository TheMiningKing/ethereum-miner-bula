#!/bin/bash

#
# Plain connection
#
#ethminer -G -F http://eth-us.dwarfpool.com:80/0x7e5533116dbd23b113d3288aacbf4d2122f88ad3/bula

#
# Detached session
#
# Use `screen -x ethminer` to attach and view `ethminer` output. Hold `Ctrl-A-D` to detach
#
#screen -dmS ethminer /usr/local/bin/ethminer -G -F http://eth-us.dwarfpool.com:80/0x7e5533116dbd23b113d3288aacbf4d2122f88ad3/bula

#
# Stratum proxy
#
# Similar to above (`Ctrl-A-D` puts process in background):
# 
# ``` 
# screen -x ethminer
# screen -x stratum
# ``` 
#
(cd /home/miner/eth-proxy && screen -dmS stratum  /usr/bin/python eth-proxy.py)
screen -dmS ethminer /usr/local/bin/ethminer --farm-recheck 200 -G -F http://127.0.0.1:8080/bula

#
# Show mining
#
screen -x ethminer
