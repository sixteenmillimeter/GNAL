#!/bin/bash

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
   CORES=`grep ^cpu\\scores /proc/cpuinfo | uniq |  awk '{print $4}'`
elif [[ "$OSTYPE" == "darwin"* ]]; then
   CORES=`sysctl -n hw.ncpu`
else
	CORES=?
fi

echo $CORES