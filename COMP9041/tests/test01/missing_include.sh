#!/bin/sh

for file in $@
do
	headfiles=`egrep "#include \".*" $file | cut -d "\"" -f2`
	for headfile in $headfiles
	do
		if [ ! -f $headfile ]
		then
			echo "$headfile" included into "$file" does not exist
		fi
	done
done
