#!/bin/bash

VERSIONS=( "v1" "v2" "v3" ) 
SIZES=( "50ft" "100ft" )


for VERSION in "${VERSIONS[@]}"
do
	:

	for SIZE in "${SIZES[@]}"
	do
		:
		echo  "./stl/${SIZE}_${VERSION} -> ./releases/gnal_${SIZE}_${VERSION} archives"
		# create zip archive and skip dotfiles
		zip -x ".*" -r "./releases/gnal_${SIZE}_${VERSION}.zip" "./stl/${SIZE}_${VERSION}/*.stl"
		# create tar.gz archive and skip dotfiles
		tar --exclude=".*" -czvf "./releases/gnal_${SIZE}_${VERSION}.tar.gz" "./stl/${SIZE}_${VERSION}/"
	done
done 