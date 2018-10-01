#!/bin/sh
# check that add works combined with commit -a
rm -rf .legit
rm -rf *.test
./legit.pl init
echo line 1 >a.test
./legit.pl add a.test
./legit.pl commit -m 'commit 0'
./legit.pl branch b1
echo line 2 >>a.test
./legit.pl checkout b1
./legit.pl status
./legit.pl checkout master
./legit.pl add a.test
./legit.pl status
./legit.pl checkout b1
./legit.pl status
./legit.pl checkout master
echo line 1 >b.test
./legit.pl commit -a -m 'commit 1'
./legit.pl rm --force a.test
./legit.pl checkout b1
./legit.pl status
echo line 2 >>b.test
./legit.pl add b.test
echo line 3 >>b.test
./legit.pl checkout master
./legit.pl status
./legit.pl checkout b1
./legit.pl log
./legit.pl checkout master
./legit.pl log