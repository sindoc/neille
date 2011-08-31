#!/bin/bash

IN_DIR=$1
IN_SUFFIX=$2
OUT_GEOMETRIES=$3
OUT_PREFIX=$4

read -p "WARNING: Do NOT run this script unless you know what you are doing. 
This program is experimental. Are you sure you want to proceed? 
If not, enter any key other than Y: "

if [[ ! $REPLY =~ Y ]]
then
  exit 1
fi

for geometry in $OUT_GEOMETRIES
do
  OUT_DIR=$OUT_PREFIX$geometry
  echo $OUT_DIR
  if [ ! -d $OUT_DIR ]; then
    mkdir -p $OUT_DIR
  fi
done

for geometry in $OUT_GEOMETRIES
do
  for image in $IN_DIR/*.$IN_SUFFIX
  do
    OUT_DIR=$OUT_PREFIX$geometry
    IMAGE_=${image/$IN_DIR\/}
    echo "Generating $OUT_DIR/$IMAGE_ from $image ..."
    convert $image -scale $geometry $OUT_DIR/$IMAGE_
  done
done
