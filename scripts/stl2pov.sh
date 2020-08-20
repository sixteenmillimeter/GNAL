#!/bin/bash

INPUT="$1"
OUTPUT="$2"

if [ "$INPUT" = "" ]; then
	exit 1
fi

if [ "$OUTPUT" = "" ]; then
	exit 1
fi

FILE_NAME=`basename "${INPUT}" .stl`
TMP_FILE=`mktemp`

stl2pov "${INPUT}" > "${TMP_FILE}"

DECLARE_LINE=`cat "${TMP_FILE}" | grep "^#declare "`
MODEL_NAME=`echo "${DECLARE_LINE}" | awk '{print $2}'`
NEW_LINE=`echo $DECLARE_LINE | sed "s/${MODEL_NAME}/${FILE_NAME}/g"`

cat "${TMP_FILE}" | sed "s/$DECLARE_LINE/$NEW_LINE/" > "${OUTPUT}"

rm "${TMP_FILE}"
echo "${FILE_NAME}"