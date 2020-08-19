#!/bin/bash

# "v1" not working as expected
VERSIONS=( "v2" "v3" ) 
SIZES=( "50ft" "100ft" )


for VERSION in "${VERSIONS[@]}"
do
	:

	for SIZE in "${SIZES[@]}"
	do
		:
		echo  "./stl/${SIZE}_${VERSION}"
		FILES=./stl/${SIZE}_${VERSION}/*.stl
		for stl in $FILES
		do
			fileSize=`wc -c < "$stl"`
			fileSize=`echo $newSize | xargs`

			firstline=`head -n 1 "$stl"`
			if [[ $firstline == solid* ]]; then
				echo "Converting $stl to binary..."
				#convert from ascii to binary
				admesh -c -b "$stl" "$stl"
				newSize=`wc -c < "$stl"`
				newSize=`echo $newSize | xargs`
				percent=`echo "scale=1;($newSize/$fileSize)*100" | bc`
				#fileSize="${newSize}"
				echo "Binary conversion created STL file ${percent}% of original"
			fi
		done

	done
done 