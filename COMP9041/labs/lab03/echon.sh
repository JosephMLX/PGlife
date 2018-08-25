#!/bin/sh

if test $# -ne 2
then
	echo "Usage: ./echon.sh <number of lines> <string>"
elif [[ $1 =~ ^[0-9]+$ ]]
then
	if test $1 -lt 0
	then
		echo "./echon.sh: argument 1 must be a non-negative integer"
	elif test $1 -eq 0
	then
		:
	else
		end=$1
		i=1
		while test $i -le $end
		do
			echo "$2"
			i=$(($i + 1))
		done
	fi
else
	echo "./echon.sh: argument 1 must be a non-negative integer"
fi
