#!/usr/bin/perl -w

@input = <STDIN>;

foreach $arg (@input) {
	$arg =~ tr/[0-4]/</;
	$arg =~ tr/[6-9]/>/;
}
	
print @input;
