#!/bin/sh
# check merge
rm -rf .legit
rm -rf *.test
./legit.pl init
echo line 1 >a.test
./legit.pl add a.test
./legit.pl commit -m 'commit 0'
./legit.pl branch b1
./legit.pl checkout b1
echo line 2 >>a.test
./legit.pl commit -a -m 'commit 1'
./legit.pl checkout master
cat a.test
echo line 3 >>a.test
cat a.test
./legit.pl commit -a -m 'commit 2'
./legit.pl merge b1 -m merge-message
./legit.pl status
