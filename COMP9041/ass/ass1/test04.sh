#!/bin/sh
# check rm function
rm -rf .legit
rm -rf *.test
./legit.pl init
echo line 1 >a.test
./legit.pl add a.test
./legit.pl commit -m 'commit 0'
# rm a non-exist file
./legit.pl rm b.test
./legit.pl rm --cached b.test
echo line 2 >>a.test
echo line 3 >b.test
# rm a file different in working tree and index
./legit.pl rm a.test
./legit.pl add a.test b.test
./legit.pl commit -m 'commit 1'
# illegal rm commands
./legit.pl rm --cached --cached a.test
./legit.pl rm --cached a.test -force
# --force and --cached sequence doesn't matter
echo line 3 >>a.test
./legit.pl add a.test
./legit.pl show :a.test
./legit.pl rm --cached --force a.test
./legit.pl show :a.test
./legit.pl add a.test
./legit.pl show :a.test
./legit.pl rm --force --cached a.test
./legit.pl show :a.test
./legit.pl add a.test
echo line 4 >>a.test
# rm a file different from last commit
./legit.pl rm a.test
# force rm
./legit.pl rm -force a.test
./legit.pl show :a.test