#!/bin/sh

for file in *
do
	if [ -e "${file%.*}".png ]
	then
		echo "${file%.*}.png already exists"
		exit 1
	fi
done

for file in *.jpg
do
	convert "$file" "${file%.*}.png"
	rm "$file"
done
