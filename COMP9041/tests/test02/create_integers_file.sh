#!/bin/sh

begin=$1
end=$2
filename=$3

while test $begin -le $end
do
	echo "$begin" >> $filename
	begin=$(($begin+1))
done

