#!/bin/sh
# all commands combined in subset0
rm -rf .legit
rm -rf *.test
./legit.pl init
echo line 1 >a.test
./legit.pl add a.test
./legit.pl commit -m 'first commit'
./legit.pl show :a.test
echo line 2 >>a.test
echo line 1 >b.test
./legit.pl add a.test b.test
./legit.pl commit -m 'second commit'
./legit.pl show 1:a.test
# non-exist commit show error
./legit.pl show 2:a.test
# non-exist file show error
./legit.pl show 1:c.test
./legit.pl log