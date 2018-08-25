#!/bin/sh

for file in *.htm
do
	name="${file%.*}.html"
	for file2 in *.html
	do
		if [ "$name" == "$file2" ]
		then
			echo "$file2 exists"
			exit 1
		fi
	done
	mv "$file" "$name"	
done

