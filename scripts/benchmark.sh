echo "Benchmarking GNAL spiral generation"

VERSION=`bash ./scripts/version.sh`
CPU=`bash ./scripts/cpu.sh`
DATE=`date -u +%s` #timestamp in seconds
NOTES="./notes/benchmark.csv"

ROTATIONS=( 1 2 5 10 20 )
DIAMETERS=( 47 225 300 )
COMPLETE=( 40 60 )

echo "version,cpu,date,source,diameter,rotations,$fn,size,time" > $NOTES

for SPIRAL in ./spiral/*.scad
do
	FILENAME=`basename ${SPIRAL}`
	echo "Rendering ${SPIRAL}..."
	for ROT in "${ROTATIONS[@]}"
	do
	   : 
		for D in "${DIAMETERS[@]}"
		do
		   : 
		    echo "Rendering ${SPIRAL} for ${ROT} rotations @ ${D}mm"
		   	TMP=`mktemp`
			start=`date +%s`
			openscad -o "${TMP}.stl" -D N=${ROT} -D D=${D} -D FN=100 "${SPIRAL}"
			end=`date +%s`
			runtime=$((end-start))
			size=`wc -c < "${TMP}.stl"`
			size=`echo $size | xargs`

			line="${VERSION},${CPU},${DATE},${FILENAME},${D},${ROT},100,$size,$runtime"
			echo $line
			echo $line >> $NOTES

			rm "${TMP}.stl"
		done
	done

	for C in "${COMPLETE[@]}"
	do
	   : 
	   	echo "Rendering complete ${SPIRAL} with ${C} rotations"
	   	TMP=`mktemp`
		start=`date +%s`
	   	echo -o "${TMP}.stl" -D N=${C} -D D=47 "${SPIRAL}"
   		end=`date +%s`
		runtime=$((end-start))
		echo "${TMP}.stl"

		#rm "${TMP}.stl"
	done
done