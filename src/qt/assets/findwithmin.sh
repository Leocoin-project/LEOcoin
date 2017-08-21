#!/bin/bash
FULL=`find .|grep -e \\\.css$ -e \\\.js$|grep -v ".min.js"|grep -v .min.css`

for file in $FULL
do
  extension="${file##*.}"
  filename="${file%.*}"

  if [ -f "$filename.min.$extension" ]
  then
    echo $filename.min.$extension
  fi
done
