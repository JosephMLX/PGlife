#!/bin/sh

filename=$1
frontname="${filename%.*}"		# get the basename of a file
backups=`find . -type f -name ".$frontname*" | wc -l`	# get the number of files named with '.filename'
if test $backups -eq 0
then
	cp "$filename" ".$filename.0"
else	
	cp "$filename" ".$filename.$backups"
	backups=$(($backups+1))
fi
if test $backups -ne 0
then
	backups=$(($backups-1))
fi
echo "Backup of '$filename' saved as '.$filename.$backups'"
