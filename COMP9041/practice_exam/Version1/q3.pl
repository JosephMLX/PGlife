#!/usr/bin/perl -w

foreach $arg (@ARGV) {
	next if $seen{$arg};
	print "$arg ";
	$seen{$arg} += 1;
}
print "\n";
