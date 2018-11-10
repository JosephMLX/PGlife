#!/bin/sh

egrep 'F$'|cut -d '|' -f 2|sort|uniq
