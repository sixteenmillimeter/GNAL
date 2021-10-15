#!/bin/bash

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
   CPU=`cat /proc/cpuinfo | grep "model name" | head -n 1 | awk '{for (i=4; i<=NF; i++) print $i}'`
elif [[ "$OSTYPE" == "darwin"* ]]; then
   CPU=`sysctl -a | grep machdep.cpu.brand_string | awk '{for (i=2; i<=NF; i++) print $i}'`
else
	CPU=-1
fi

echo $CPU