#!/bin/bash

set -e

V="v3"

echo "Rendering GNAL ${V}"

bash ./scripts/deps.sh
bash ./scripts/license.sh

VERSION=`bash ./scripts/version.sh`
CPU=`bash ./scripts/cpu.sh`
DIST=./stl
CSG=./csg
IMG=./img
NOTES=./notes/${V}.csv
STEP=false
LOGGING=true

#"quarter_a" "quarter_b" "quarter_c" "quarter_d"
#quarter pieces not rendering properly

FILES=( 
	"spindle_bottom" 
	"spindle_bottom_reinforced"
	"spindle_top" 
	"spindle_top_reinforced"
	"spindle_single"  
	"insert_s8" 
	"insert_16" 
	"spacer_16" 
	"insert_single"
	"top" 
	"spiral" 
)
SIZES=( "50ft" "100ft" ) 

mkdir -p "${DIST}"

render_part () {
	scad="${1}"
	SIZE="${2}"
	FILE="${3}"
	stl="${DIST}/${SIZE}_${V}/gnal_${SIZE}_${FILE}.stl"
	csg="${CSG}/${SIZE}_${V}/gnal_${SIZE}_${FILE}.csg"
	png="${IMG}/gnal_${SIZE}_${V}_${FILE}.png"

	if [ $STEP = true ]; then
		mkdir -p "${CSG}"
		mkdir -p "${CSG}/${SIZE}_${V}/"
	fi

	echo "${scad} - ${FILE}"

	start=`date +%s`
	if [[ "${SIZE}" == "100ft" ]]; then
		openscad --backend=manifold --csglimit=2000000 -o "${stl}" -D "PART=\"${FILE}\"" -D "FN=800" "${scad}"
	else
		openscad --backend=manifold --csglimit=1000000 -o "${stl}" -D "PART=\"${FILE}\"" -D "FN=600" "${scad}"
	fi

	echo "Canonicalizing STL ${stl}..."
	#canonicalize the file to prevent unneeded diffs in updated models
	python3 ./scripts/c14n_stl.py "${stl}"
	
	end=`date +%s`
	runtime=$((end-start))

	fileSize=`wc -c < "$stl"`
	fileSize=`echo $fileSize | xargs`

	if ! [ -x "$(command -v admesh)" ]; then
		facets="N/A"
		volume="N/A"
	else
		firstline=`head -n 1 "${stl}"`
		if [[ $firstline == solid* ]]; then
			#convert from ascii to binary
			tmpBinary=`mktemp`
			admesh -c -b "$tmpBinary" "$stl"
			newSize=`wc -c < "$tmpBinary"`
			newSize=`echo $newSize | xargs`

			if [ $newSize -lt $fileSize ]; then
				cp "$tmpBinary" "$stl"
				percent=`echo "scale=1;($newSize/$fileSize)*100" | bc`
				fileSize="${newSize}"
				echo "Binary conversion created STL file ${percent}% of original"
			else
				echo "Binary STL is larger than ASCII original, skipping conversion..."
			fi
			rm "$tmpBinary"
		fi
		ao=`admesh -c "$stl"`
		facets=`echo "$ao" | grep "Number of facets" | awk '{print $5}'`
		volume=`echo "$ao" | grep "Number of parts"  | awk '{print $8}'`
	fi

	hash=`sha256sum "$stl" | awk '{ print $1 }'`

	if [ ${LOGGING} = true ]; then
		line="${VERSION},${CPU},$stl,$hash,$fileSize,$srchash,$srcsize,$facets,$volume,$runtime"
		echo "$line" >> $NOTES
		echo "$line"
	fi

	if [ $STEP = true ]; then
		echo "Rendering CSG of ${stl}..."
		start=`date +%s`

		if [[ "${SIZE}" == "100ft" ]]; then
			openscad --backend=manifold --csglimit=20000000 -o "$csg" -D "PART=\"${FILE}\"" -D "FN=800" "${scad}"
		else
			openscad --backend=manifold --csglimit=10000000 -o "$csg" -D "PART=\"${FILE}\"" -D "FN=600" "${scad}"
		fi
		
		end=`date +%s`
		runtime=$((end-start))
	fi

	echo "Rendering image of ${stl}..."

	if [[ "${FILE}" == "spiral" ]]; then
		tmp=`mktemp`
		fullPath=`realpath "${stl}"`
		data="import(\"${fullPath}\");"
		echo "${data}" > "${tmp}.scad"
		openscad -o "$png" --backend=manifold --imgsize=2048,2048 --csglimit=20000000 --colorscheme=DeepOcean "${tmp}.scad"
	else
		openscad -o "$png" --backend=manifold --imgsize=2048,2048 --csglimit=10000000 --colorscheme=DeepOcean -D "PART=\"${FILE}\"" "${scad}"
	fi
}

if [[ "${1}" != "" ]]; then
	LOGGING=false
	SIZE="${1}"
	scad="./scad/${SIZE}_${V}/gnal_${SIZE}.scad"

	mkdir -p "${DIST}/${SIZE}_${V}"
	if [[ "${2}" != "" ]]; then
		FILE="${2}"
		render_part "${scad}" "${SIZE}" "${FILE}"
	else 
		for FILE in "${FILES[@]}"; do
			render_part "${scad}" "${SIZE}" "${FILE}"
		done
	fi
	exit 0
fi

echo "version,cpu,file,file_hash,file_size,source_hash,source_size,facets,volume,render_time" > $NOTES

for SIZE in "${SIZES[@]}"
do
	:
	scad="./scad/${SIZE}_${V}/gnal_${SIZE}.scad"
	srchash=`sha256sum "${scad}" | awk '{ print $1 }'`
	srcsize=`wc -c < "${scad}"`
	srcsize=`echo $srcsize | xargs`
	
	mkdir -p "${DIST}/${SIZE}_${V}"

	for FILE in "${FILES[@]}"; do
		render_part "${scad}" "${SIZE}" "${FILE}"
	done

	# add license to directories for zip
	cp ./LICENSE.txt "./stl/${SIZE}_${V}/"
	mkdir -p ./releases
	# zip all
	zip -x ".*" -r "./releases/gnal_${SIZE}_${V}.zip" "./stl/${SIZE}_${V}/"
	# tar all
	tar --exclude=".*" -czvf "./releases/gnal_${SIZE}_${V}.tar.gz" "./stl/${SIZE}_${V}/"
	rm -rf "./stl/${SIZE}_${V}/LICENSE.txt"
	echo "Released ${SIZE}_${V}"
done

