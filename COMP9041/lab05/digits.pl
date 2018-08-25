#!/usr/bin/perl

$numArgs = $#ARGV + 1;
foreach $argnum (0..$#ARGV) {
	$ARGV[$argnum] =~ tr/[0-4]/</;
	$ARGV[$argnum] =~ tr/[6-9]/>/;
	print "$ARGV[$argnum] ";
}
