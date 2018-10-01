#!/bin/sh
# check branch function
rm -rf .legit
rm -rf *.test
./legit.pl init
echo line 1 >a.test
./legit.pl add a.test
./legit.pl commit -m 'commit 0'
# illegal commit command
./legit.pl branch b1 b2
# create a branch called 'master'
./legit.pl branch master
# invilid branch name
./legit.pl branch *b1
# correct new branch name
./legit.pl branch b1
# check current branches
./legit.pl branch
./legit.pl branch b2
./legit.pl branch -d b1
./legit.pl branch