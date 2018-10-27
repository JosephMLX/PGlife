#!/bin/sh

cat $1 | egrep -e "name" | cut -d ':' -f 2 | cut -d ',' -f 1 | cut -d '"' -f 2 | sed 's/"//g' | sort | uniq;
