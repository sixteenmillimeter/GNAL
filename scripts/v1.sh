#!/bin/bash

echo "Rendering GNAL v1"

VERSION=`bash ./scripts/version.sh`
CPU=`bash ./scripts/cpu.sh`
DIST=./stl/
NOTES=./notes/v1.csv
FILES=( "spacer" "top" "spiral_top" "spiral_bottom" )
SIZES=( "50ft" "100ft" ) 

mkdir -p $DIST

echo "version,cpu,file,file_hash,file_size,source_hash,source_size,facets,volume,render_time" > $NOTES

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
	    stl="${DIST}/${SIZE}_v1/gnal_${SIZE}_${FILE}.stl"
	    scad="${SIZE}_v1/${FILE}.scad"
	    echo "$scad"
	    start=`date +%s`
		openscad -o "$stl" "$scad"
		end=`date +%s`
		runtime=$((end-start))
		hash=`sha256sum "$stl" | awk '{ print $1 }'`
		fileSize=`wc -c < "$stl"`
		fileSize=`echo $fileSize | xargs`
		ao=`admesh -c "$stl"`
		facets=`echo "$ao" | grep "Number of facets" | awk '{print $5}'`
		volume=`echo "$ao" | grep "Number of parts"  | awk '{print $8}'`
		line="${VERSION},${CPU},gnal_${SIZE}_${FILE}.stl,$hash,$fileSize,$srchash,$srcsize,$facets,$volume,$runtime"
		echo "$line" >> $NOTES
		echo "$line"
	done
done
