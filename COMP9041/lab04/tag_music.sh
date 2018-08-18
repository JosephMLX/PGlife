#!/bin/sh

for folder in "$@"
do
	for file in "$folder"/*.mp3 
	do
		if test -e "$file"
		then
			id3 -t "`ls -l "$file" | cut -d ' ' -f10- | cut -d '-' -f2 | cut -c2-`" "$file" 1>/dev/null
			id3 -a "`ls -l "$file" | cut -d ' ' -f10- | cut -d '-' -f3 | sed s/'.mp3'//g | cut -c2-`" "$file" 1>/dev/null
			id3 -A "`ls -l "$file" | cut -d '/' -f2`" "$file" 1>/dev/null
			id3 -y "`ls -l "$file" | cut -d '/' -f2 | cut -d ',' -f2 | cut -c2-`, Genre: Unknown (255)" "$file" 1>/dev/null
			id3 -T "`ls -l "$file" | cut -d ',' -f2 | cut -d '-' -f1 | cut -d '/' -f2- | sed -e 's/\///g'`" "$file" 1>/dev/null
		#echo "`ls -l "$file" | cut -d ',' -f2 | cut -d '-' -f1 | cut -d '/' -f2- | sed -e 's/\///g'`"
		fi
	done
done

