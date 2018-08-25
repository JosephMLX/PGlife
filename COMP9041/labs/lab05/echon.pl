#!/usr/bin/perl -w

if ("$#ARGV" != 1) {
	print "Usage: ./echon.pl <number of lines> <string>\n";
} elsif ($ARGV[0] =~ /\D/) {
	print "./echon.pl: argument 1 must be a non-negative integer\n";
} else {
	$time = $ARGV[0];
	for ($i=1; $i<=$time; $i++) {
		print "$ARGV[1]\n";
	}
}

