#!/bin/bash

YEAR=`cat LICENSE.txt | grep "^Copyright" | awk '{print $3}'`
NOW=`date '+%Y'`

if [ $NOW -gt $YEAR ]; then
	echo "Current year $NOW > $YEAR, updating license..."
	LICENSE=`cat LICENSE.txt`
	UPDATED=`echo "${LICENSE}" | sed "s/${YEAR}/${NOW}/"`
	echo "${UPDATED}" > LICENSE.txt
fi

