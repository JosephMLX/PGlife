#!/bin/sh
# check checkout function
rm -rf .legit
rm -rf *.test
./legit.pl init
echo line 1 >a.test
./legit.pl add a.test
./legit.pl commit -m 'commit on master'
./legit.pl branch b1
./legit.pl checkout b1
echo line 2 >>a.test
./legit.pl add a.test
./legit.pl commit -m 'commit on b1'
echo line 3 >b.test
./legit.pl add b.test
./legit.pl commit -m 'commit on b1'
./legit.pl show :a.test
# log on branch b1
./legit.pl log
./legit.pl checkout master
./legit.pl show :a.test
# log on branch master
./legit.pl log
./legit.pl show 2:b.test
./legit.pl status
# remove branch b1
./legit.pl branch -d b1
./legit.pl show :b.test
# create branch b1 again and check what in b1
./legit.pl branch b1
./legit.pl checkout b1
./legit.pl log
./legit.pl status