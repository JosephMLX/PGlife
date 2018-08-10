#!/bin/sh

S="Small files: "
M="Medium-sized files: "
L="Large files: "

for file in *
do
	lines=`wc -l < "$file"`
	if test $lines -lt 10
	then
		S+="$file "
	elif test $lines -lt 100
	then
		M+="$file "
	else
		L+="$file "
	fi
done
		
echo $S
echo $M
echo $L
