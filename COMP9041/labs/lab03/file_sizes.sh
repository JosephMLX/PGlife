#!/bin/sh

S="Small files: "
M="Medium-sized files: "
L="Large files: "

for file in *
do
	lines=`wc -l < "$file"`
	if test $lines -lt 10
	then
		# S+="$file " # not good
		S="$S $file"  # better
	elif test $lines -lt 100
	then
		# M+="$file "
		M="$M $file"
	else
		# L+="$file "
		L="$L $file"
	fi
done
		
echo $S
echo $M
echo $L
