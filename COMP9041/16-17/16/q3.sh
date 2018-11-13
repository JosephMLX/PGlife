#!/bin/sh

cat numbers | sed 's/[a-z].*[a-z]//g'
