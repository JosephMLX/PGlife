#!/bin/sh
# check all illegal commond output and illegal init output
rm -rf .legit
rm -rf *.test
# no input
./legit.pl
# illegal command
./legit.pl ini
# other commands follow init
./legit.pl init init
# correct init command
./legit.pl init
# init again
./legit.pl init
