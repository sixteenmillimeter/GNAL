#!/bin/bash

VERSIONS=( "v1" "v2" "v3" ) 
SIZES=( "50ft" "100ft" )


for VERSION in "${VERSIONS[@]}"
do
	:

	for SIZE in "${SIZES[@]}"
	do
		:
		echo  "./stl/${SIZE}_${VERSION} -> ./releases/gnal_${SIZE}_${VERSION}.zip"
		zip -r "./releases/gnal_${SIZE}_${VERSION}.zip" "./stl/${SIZE}_${VERSION}/*.stl"
	done
done 