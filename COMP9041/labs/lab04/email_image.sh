#!/bin/sh

for file in $@
do
	display $file
	echo -n "Address to e-mail this image to? "
	read address
	echo -n "Message to accompany image? "
	read message
	subject="${file%.*}!"
	echo "$message" | mutt -s "$subject" -e 'set copy=no' -a "$file" -- "$address"
	echo $file sent to $address
done
