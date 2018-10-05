#!/bin/sh

dir1=$1;
dir2=$2;

files="$dir1/*"

for file in $files
do
  file1=`echo "$file" | cut -d '/' -f 2`
  if `cmp --s $dir1/"$file1" $dir2/"$file1"`
  then
     echo "$file1"
  fi
done

