#!/bin/sh
# all commands combined in subset1
rm -rf .legit
rm -rf *.test
./legit.pl init
echo line 1 >a.test
echo line 1 >b.test
echo line 1 >c.test
echo line 1 >d.test
./legit.pl add a.test b.test c.test d.test
./legit.pl commit -m 'commit 0'
echo line 2 >>a.test
echo line 2 >>b.test
./legit.pl add a.test
echo line 3 >>a.test
touch e.test
./legit.pl add e.test
./legit.pl rm --cached c.test
rm c.test
./legit.pl status