#!/bin/sh

for file in $1
do
	echo `ls -l $file`
done
