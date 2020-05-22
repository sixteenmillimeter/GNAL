echo "Benchmarking GNAL spiral generation"

VERSION=`bash ./scripts/version.sh`
CPU=`bash ./scripts/cpu.sh`
DATE=`date -u +%s` #timestamp in seconds
NOTES="./notes/benchmark.csv"

ROTATIONS=( 1 2 ) # 5 10 20 )
DIAMETERS=( 47 ) # 225 300 )
COMPLETE=( 40 60 )

mkdir -p benchmark

echo "version,cpu,date,source,diameter,rotations,fn,size,facets,volume,time" > $NOTES

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
		   	#TMP=`mktemp`
		   	TMP="benchmark/${FILENAME}_${D}_${ROT}_100"
			start=`date +%s`
			openscad -o "${TMP}.stl" -D N=${ROT} -D D=${D} -D FN=100 "${SPIRAL}"
			end=`date +%s`
			runtime=$((end-start))
			size=`wc -c < "${TMP}.stl"`
			size=`echo $size | xargs`
			ao=`admesh -c "${TMP}.stl"`
			facets=`echo "$ao" | grep "Number of facets" | awk '{print $5}'`
			volume=`echo "$ao" | grep "Number of parts"  | awk '{print $8}'`

			line="${VERSION},${CPU},${DATE},${FILENAME},${D},${ROT},100,$size,$facets,$volume,$runtime"
			echo $line
			echo $line >> $NOTES

			#rm "${TMP}.stl"
		done
	done

	for C in "${COMPLETE[@]}"
	do
	   : 
	   	echo "Rendering complete ${SPIRAL} with ${C} rotations"
	   	#TMP=`mktemp`
	   	TMP="benchmark/${FILENAME}_${D}_${ROT}_100"
		start=`date +%s`
	   	echo -o "${TMP}.stl" -D N=${C} -D D=47 "${SPIRAL}"
   		end=`date +%s`
		runtime=$((end-start))
		size=`wc -c < "${TMP}.stl"`
		size=`echo $size | xargs`
		ao=`admesh -c "${TMP}.stl"`
		facets=`echo $ao | grep "Number of facets" | awk '{print $5}'`
		volume=`echo $ao | grep "Number of parts"  | awk '{print $8}'`

		line="${VERSION},${CPU},${DATE},${FILENAME},${D},${ROT},100,$size,$facets,$volume,$runtime"
		#echo $line >> $NOTES
		echo $line

		#rm "${TMP}.stl"
	done
done