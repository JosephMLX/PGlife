#!/bin/sh

cat numbers|sed 's/[a-j].*/ /g'|sort
