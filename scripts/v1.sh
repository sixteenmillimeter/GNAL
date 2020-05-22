#!/bin/bash

echo "Compiling GNAL v1"

VERSION=`openscad -v 2>&1 >/dev/null | awk '{print $3}'`
DIST=./dist/
NOTES=./notes/v1.csv
FILES=( "spacer" "top" "spiral_top" "spiral_bottom" )
SIZES=( "50ft" "100ft" ) 

mkdir -p $DIST

echo "version,cpu,file,file_hash,file_size,source_hash,source_size,render_time" > $NOTES

for SIZE in "${SIZES[@]}"
do
	:
	mkdir -p "${DIST}/${SIZE}_v1"
	srchash=`sha256sum "${SIZE}_v1/gnal_${SIZE}.scad" | awk '{ print $1 }'`
	srcsize=`wc -c < "${SIZE}_v1/gnal_${SIZE}.scad"`
	srcsize=`echo $srcsize | xargs`

	for FILE in "${FILES[@]}"
	do
	   : 
	    echo "${SIZE}_v1/${FILE}.scad"
	    start=`date +%s`
		openscad -o "${DIST}/${SIZE}_v1/gnal_${SIZE}_${FILE}.stl" "${SIZE}_v1/${FILE}.scad"
		end=`date +%s`
		runtime=$((end-start))
		hash=`sha256sum "${DIST}/${SIZE}_v1/gnal_${SIZE}_${FILE}.stl" | awk '{ print $1 }'`
		fileSize=`wc -c < "${DIST}/${SIZE}_v1/gnal_${SIZE}_${FILE}.stl"`
		fileSize=`echo $fileSize | xargs`
		echo "gnal_${SIZE}_${FILE}.stl,$hash,$fileSize,$srchash,$srcsize,$runtime" >> $NOTES
	done
done
