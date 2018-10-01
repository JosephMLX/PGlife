#!/bin/sh
# check that add works
rm -rf .legit
rm -rf *.test
./legit.pl init
# add a file
./legit.pl add a.test
echo line 1 >a.test
./legit.pl add a.test
./legit.pl commit -m 'first commit'
./legit.pl show :a.test
./legit.pl show 0:a.test
# add an edited file
echo line 2 >>a.test
./legit.pl add a.test
./legit.pl commit -m 'second commit'
./legit.pl show :a.test
./legit.pl show 1:a.test
# remove a file in working tree and add it to index
rm a.test
./legit.pl add a.test
./legit.pl commit -m 'third commit'
./legit.pl show :a.test
./legit.pl show 2:a.test
# invilid added filename
echo line 1 >_a.test
./legit.pl add _a.test
# add a file doesn't exist
echo line 1 >a.test
./legit.pl add a.test
./legit.pl add a.test
echo line 1 >b.test
./legit.pl add a.test b.test c.test
./legit.pl show :b.test