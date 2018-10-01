#!/bin/sh
# check commit function
rm -rf .legit
rm -rf *.test
./legit.pl init
echo line 1 >a.test
./legit.pl add a.test
# illegal commit commands
./legit.pl commit -mm 'commit0'
./legit.pl commit -m 'commit0' 'commit0'
# correct commit -m command
./legit.pl commit -m 'commit0'
echo line 2 >>a.test
echo line 1 >b.test
# illegal command -a -m commands
./legit.pl commit -m -a 'commit1'
./legit.pl commit -m 'commit1' -a
./legit.pl commit -a -m 'commit1'
./legit.pl log