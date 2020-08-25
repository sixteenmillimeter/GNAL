#!/bin/bash

FILE="$1"

if [ "$FILE" = "" ]; then
	echo -1
	exit 1
fi

#wc -c < "$FILE"
#exit 0

if [ "$(uname)" == "Darwin" ]; then
    # Mac OS X platform 
    stat -f%z "${FILE}"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # GNU/Linux platform
    stat -c%s "${FILE}"
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    # 32 bits Windows NT platform
    echo -1
	exit 2
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
    # 64 bits Windows NT platform
    echo -1
	exit 3
fi