#!/bin/bash

STL="$1"

#const elapsedParse = 'Total time elapsed  '
#const timeParse = 'Print time (s): '
#const timeStrParse = 'Print time (hr|min|s): '
#const materialParse = 'Filament (mm^3): '


if ! [ -x "$(command -v curaengine)" ]; then
	echo "printtime N/A"
	echo "volume N/A"
	echo "slicetime N/A"
else
	start=`date +%s`
	output=`bash ./scripts/curaengine.sh "${STL}"`
	end=`date +%s`
	slicetime=$((end-start))

	echo "printtime ${printtime}"
	echo "volume ${volume}"
	echo "slicetime ${slicetime}"
fi