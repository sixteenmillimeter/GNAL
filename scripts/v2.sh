#!/bin/bash
V="v2"

echo "Rendering GNAL ${V}"

VERSION=`bash ./scripts/version.sh`
CPU=`bash ./scripts/cpu.sh`
DIST=./dist
IMG=./img

NOTES=./notes/${V}.csv
FILES=( "spacer" "top" "spiral" "insert_s8" "insert_16" "spacer_16" )
SIZES=( "50ft" "100ft" ) 

mkdir -p $DIST

echo "version,cpu,file,file_hash,file_size,source_hash,source_size,facets,volume,render_time" > $NOTES

for SIZE in "${SIZES[@]}"
do
	:
	mkdir -p "${DIST}/${SIZE}_${V}"
	scad="${SIZE}_${V}/gnal_${SIZE}.scad"
	srchash=`sha256sum "${scad}" | awk '{ print $1 }'`
	srcsize=`wc -c < "${scad}"`
	srcsize=`echo $srcsize | xargs`

	for FILE in "${FILES[@]}"
	do
	   : 
	    stl="${DIST}/${SIZE}_${V}/gnal_${SIZE}_${FILE}.stl"
	    png="${IMG}/gnal_${SIZE}_${V}_${FILE}.png"
	    echo "${scad} - ${FILE}"
	    start=`date +%s`
		openscad -o "$stl" -D "PART=\"${FILE}\"" "${scad}"
		end=`date +%s`
		runtime=$((end-start))
		hash=`sha256sum "$stl" | awk '{ print $1 }'`
		fileSize=`wc -c < "$stl"`
		fileSize=`echo $fileSize | xargs`
		ao=`admesh -c "$stl"`
		facets=`echo "$ao" | grep "Number of facets" | awk '{print $5}'`
		volume=`echo "$ao" | grep "Number of parts"  | awk '{print $8}'`
		line="${VERSION},${CPU},$stl,$hash,$fileSize,$srchash,$srcsize,$facets,$volume,$runtime"
		echo "$line" >> $NOTES
		echo "$line"

		echo "Rendering image of ${stl}..."

		openscad -o "$png" --preview --imgsize=1920,1080 --colorscheme=DeepOcean -D "PART=\"${FILE}\"" "${scad}"
	done
done