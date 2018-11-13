#!/usr/bin/perl

while ($line = <STDIN>) {
	$line =~ s/[aeiou]//g;
	print $line;
}
