#!/bin/sh
for file in $@
do
	detail=`ls -l $file | cut -d ' ' -f6-8`
	convert -gravity south -pointsize 36 -draw "text 0,10 '$detail'" $file $file
done
