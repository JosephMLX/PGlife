#!/usr/bin/perl

while ($line = <STDIN>) {
	print "$line\n" if $line eq "hello";
	print "$line\n" if $line eq "42";
}
