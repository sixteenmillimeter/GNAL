#!/bin/bash

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
   CPU=-1
elif [[ "$OSTYPE" == "darwin"* ]]; then
   CPU=`sysctl -a | grep machdep.cpu.brand_string | awk '{for (i=2; i<=NF; i++) print $i}'`
else
	CPU=-1
fi


echo $CPU