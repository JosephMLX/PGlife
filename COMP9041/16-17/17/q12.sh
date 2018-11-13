#!/bin/bash

u=$1
v=$2
while (( $v != 0 ))
do
	t=$u
	u=$v
	v=`expr $t % $v`
done
echo "The gcd of $1 and $2 is $u"
